//
// Copyright 2022 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import SafariServices
import SignalServiceKit

public class NewPrivateStoryConfirmViewController: OWSTableViewController2 {

    let recipientSet: OrderedSet<PickedRecipient>
    let selectItemsInParent: (([StoryConversationItem]) -> Void)?
    var allowsReplies = true

    init(recipientSet: OrderedSet<PickedRecipient>, selectItemsInParent: (([StoryConversationItem]) -> Void)? = nil) {
        self.recipientSet = recipientSet
        self.selectItemsInParent = selectItemsInParent

        super.init()

        self.shouldAvoidKeyboard = true
    }

    // MARK: - View Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = OWSLocalizedString(
            "NEW_PRIVATE_STORY_CONFIRM_TITLE",
            comment: "Title for the 'new private story' confirmation view"
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: OWSLocalizedString(
                "NEW_PRIVATE_STORY_CREATE_BUTTON",
                comment: "Button to create a new private story"
            ),
            style: .plain,
            target: self,
            action: #selector(didTapCreate)
        )

        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.reuseIdentifier)

        updateTableContents()
    }

    private var lastViewSize = CGSize.zero
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard view.frame.size != lastViewSize else { return }
        lastViewSize = view.frame.size
        updateTableContents()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        nameTextField.becomeFirstResponder()
    }

    // MARK: -

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()

        textField.font = .dynamicTypeBody
        textField.backgroundColor = .clear
        textField.placeholder = OWSLocalizedString(
            "NEW_PRIVATE_STORY_NAME_PLACEHOLDER",
            comment: "Placeholder text for a new private story name"
        )

        return textField
    }()

    public override func themeDidChange() {
        super.themeDidChange()

        nameTextField.textColor = Theme.primaryTextColor
    }

    private func updateTableContents() {
        let contents = OWSTableContents()

        let nameAndAvatarSection = OWSTableSection()
        nameAndAvatarSection.footerTitle = OWSLocalizedString(
            "NEW_PRIVATE_STORY_NAME_FOOTER",
            comment: "Section footer for the name text field on the 'new private story' creation view"
        )
        nameAndAvatarSection.add(.init(
            customCellBlock: { [weak self] in
                let cell = OWSTableItem.newCell()
                cell.selectionStyle = .none
                guard let self = self else { return cell }

                cell.contentView.addSubview(self.nameTextField)
                self.nameTextField.autoPinEdgesToSuperviewMargins()

                return cell
            },
            actionBlock: {}
        ))
        contents.add(nameAndAvatarSection)

        let repliesSection = OWSTableSection()
        repliesSection.headerTitle = StoryStrings.repliesAndReactionsHeader
        repliesSection.footerTitle = StoryStrings.repliesAndReactionsFooter
        contents.add(repliesSection)

        repliesSection.add(.switch(
            withText: StoryStrings.repliesAndReactionsToggle,
            isOn: { [allowsReplies] in allowsReplies },
            target: self,
            selector: #selector(didToggleReplies)
        ))

        let viewerAddresses = SSKEnvironment.shared.databaseStorageRef.read { transaction in
            return BaseMemberViewController.sortedMemberAddresses(
                recipientSet: self.recipientSet,
                tx: transaction
            )
        }

        let viewersSection = OWSTableSection()
        viewersSection.headerTitle = OWSLocalizedString(
            "NEW_PRIVATE_STORY_VIEWERS_HEADER",
            comment: "Header for the 'viewers' section of the 'new private story' view"
        )

        for address in viewerAddresses {
            viewersSection.add(OWSTableItem(
                dequeueCellBlock: { tableView in
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.reuseIdentifier) as? ContactTableViewCell else {
                        owsFailDebug("Missing cell.")
                        return UITableViewCell()
                    }

                    cell.selectionStyle = .none

                    SSKEnvironment.shared.databaseStorageRef.read { transaction in
                        let configuration = ContactCellConfiguration(address: address, localUserDisplayMode: .asUser)
                        cell.configure(configuration: configuration, transaction: transaction)
                    }
                    return cell
                }))
        }
        contents.add(viewersSection)

        self.contents = contents
    }

    // MARK: - Actions

    @objc
    private func didTapCreate() {
        AssertIsOnMainThread()

        guard let name = nameTextField.text?.filterForDisplay.nilIfEmpty else {
            return showMissingNameAlert()
        }

        let allowsReplies = self.allowsReplies
        let serviceIds = self.recipientSet.orderedMembers.compactMap { $0.address?.serviceId }

        Task {
            let databaseStorage = SSKEnvironment.shared.databaseStorageRef
            let threadUniqueId = await databaseStorage.awaitableWrite { tx in
                let newStory = TSPrivateStoryThread(
                    name: name,
                    allowsReplies: allowsReplies,
                    viewMode: .explicit
                )
                newStory.anyInsert(transaction: tx)

                let recipientFetcher = DependenciesBridge.shared.recipientFetcher
                let recipientIds = serviceIds.map { recipientFetcher.fetchOrCreate(serviceId: $0, tx: tx).id! }

                let storyRecipientManager = DependenciesBridge.shared.storyRecipientManager
                failIfThrows {
                    try storyRecipientManager.setRecipientIds(
                        recipientIds,
                        for: newStory,
                        shouldUpdateStorageService: true,
                        tx: tx
                    )
                }

                return newStory.uniqueId
            }
            self.dismiss(animated: true)
            self.selectItemsInParent?(
                [StoryConversationItem(
                    backingItem: .privateStory(.init(storyThreadId: threadUniqueId, isMyStory: false)),
                    storyState: nil
                )]
            )
        }
    }

    @objc
    private func didToggleReplies() {
        allowsReplies = !allowsReplies
    }

    public func showMissingNameAlert() {
        AssertIsOnMainThread()

        OWSActionSheets.showActionSheet(
            title: OWSLocalizedString(
                "NEW_PRIVATE_STORY_MISSING_NAME_ALERT_TITLE",
                comment: "Title for error alert indicating that a story name is required."
            ),
            message: OWSLocalizedString(
                "NEW_PRIVATE_STORY_MISSING_NAME_ALERT_MESSAGE",
                comment: "Message for error alert indicating that a story name is required."
            )
        )
    }
}
