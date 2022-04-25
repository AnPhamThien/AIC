class MessageCode {
  static Map<String, String> errorMap = {
    userNotFound: "User not found.",
    addUserInfoNotValid: "User's info is invalid.",
    userEmailExist: "User's email already used.",
    userAccountInActivated: "User's account is not activated.",
    userAccountDeleted: "User's account has been deleted.",
    userStorageNotFound: "User's storage is not found.",
    userNameExist: "Username already used.",
    userMailNotFound: "There is no account associated with this email.",
    oldPassWord: "Old password.",
    userPassWordInCorrect: "Please check your username and password.",
    getUserDetailFail: "Get user's details fail.",
    getMoreUserPostFail: "Get more user's posts fail.",
    getUserAccountFail: "Get user account fail.",
    noUserAccountToDisplay: "No user account to display.",
    postNotFound: "Post not found.",
    noPostToDisplay: "There is no post to display.",
    albumNotFound: "There is no album yet.",
    albumNameIsDuplicated: "There is already an album with this name.",
    addPostInforNotValid: "Post's info is invalid.",
    contestNotFound: "Poll has ended.",
    commentNotFound: "Comment not found.",
    noCommentToDisplay: "There is no comment to display.",
    codeIsExpired:
        "Your confirmation has already expired. Please click on resend code button.",
    postReferenceBelongtoRequestUser: "You cannot save your own post.",
    noNotificationToDisplay: "There is no notification to display.",
    conversationNotFound: "Conversation not found.",
    noConversationToDisplay: "There is no conversation to display.",
    codeNotFound: "Wrong code.",
    duplicatePostInContest: "You have already posted in this poll.",
    reportExist: "You have already reported this post. Please wait for the system to pr0ocess.",
    aiIsNotActive: "AI is not active.",
    stillPostInDeletedAlbum: "If you want to delete this album, please delete all of its posts beforehand.",
    contestHasBeenClosed: "Contest has been closed."
  };

  static const String genericError = "Something went wrong";

  /// <summary>
  /// U111 : user not found or deleted
  /// </summary>
  static const String userNotFound = "U111";

  /// <summary>
  /// U112 : user info for add invalid
  /// </summary>
  static const String addUserInfoNotValid = "U112";

  /// <summary>
  /// U113 : user email exist
  /// </summary>
  static const String userEmailExist = "U113";

  /// <summary>
  /// U114 : add user fail
  /// </summary>
  static const String addUserFail = "U114";

  /// <summary>
  /// U115 : user account inactivated
  /// </summary>
  static const String userAccountInActivated = "U115";

  /// <summary>
  /// U116 : user account has been deleted
  /// </summary>
  static const String userAccountDeleted = "U116";

  /// <summary>
  /// U117 : user storage not found
  /// </summary>
  static const String userStorageNotFound = "U117";

  /// <summary>
  /// U120 : user name exist
  /// </summary>
  static const String userNameExist = "U120";

  /// <summary>
  /// U118 : user mail not found
  /// </summary>
  static const String userMailNotFound = "U118";

  /// <summary>
  /// U119 : reset password for user fail
  /// </summary>
  static const String resetPassWordForUserFail = "U119";

  /// <summary>
  /// U121 : user use old password
  /// </summary>
  static const String oldPassWord = "U121";

  /// <summary>
  /// U122 : update user fail
  /// </summary>
  static const String updateUserFail = "U122";

  /// <summary>
  /// U123 : change password fail
  /// </summary>
  static const String changePassWordFail = "U123";

  /// <summary>
  /// U124 : user password incorrect
  /// </summary>
  static const String userPassWordInCorrect = "U124";

  /// <summary>
  /// U125 : get user detail fail
  /// </summary>
  static const String getUserDetailFail = "U125";

  /// <summary>
  /// U126 : get more user post fail
  /// </summary>
  static const String getMoreUserPostFail = "U126";

  /// <summary>
  /// U127 : get user account fail
  /// </summary>
  static const String getUserAccountFail = "U127";

  /// <summary>
  /// U128 : no user account to display
  /// </summary>
  static const String noUserAccountToDisplay = "U128";

  /// <summary>
  /// U129 : delete account fail
  /// </summary>
  static const String deleteAccountFail = "U129";

  /// <summary>
  /// P111 : post not found
  /// </summary>
  static const String postNotFound = "P111";

  /// <summary>
  /// P112 : No post to display
  /// </summary>
  static const String noPostToDisplay = "P112";

  /// <summary>
  /// P113 : get post fail
  /// </summary>
  static const String getPostFail = "P113";

  /// <summary>
  /// UP111 : upload file fail due to some error
  /// </summary>
  static const String upLoadFileFail = "UP111";

  /// <summary>
  /// IMG111 : image not found
  /// </summary>
  static const String imgNotFound = "IMG111";

  /// <summary>
  /// IMG112 : get image error in AWSS3FileService.cs
  /// </summary>
  static const String getImgError = "IMG112";

  /// <summary>
  /// ALB111 : user has no album
  /// </summary>
  static const String albumNotFound = "ALB111";

  /// <summary>
  /// ALB112 : get album fail
  /// </summary>
  static const String getAlbumFail = "ALB112";

  /// <summary>
  /// ALB113 : add album fail
  /// </summary>
  static const String addAlbumFail = "ALB113";

  /// <summary>
  /// ALB114 : album name is duplicated
  /// </summary>
  static const String albumNameIsDuplicated = "ALB114";

  /// <summary>
  /// ALB115 : update album fail
  /// </summary>
  static const String updateAlbumFail = "ALB115";

  /// <summary>
  /// ALB116 : delete album fail
  /// </summary>
  static const String deleteAlbumFail = "ALB116";

  /// <summary>
  /// P114 : add post infor not valid
  /// </summary>
  static const String addPostInforNotValid = "P114";

  /// <summary>
  /// P115 : add post fail
  /// </summary>
  static const String addPostFail = "P115";

  /// <summary>
  /// P116 : update post fail
  /// </summary>
  static const String updatePostFail = "P116";

  /// <summary>
  /// P117 : delete post fail
  /// </summary>
  static const String deletePostFail = "P117";

  /// <summary>
  /// P118 : post not belong to current user
  /// </summary>
  static const String postNotBelong = "P118";

  /// <summary>
  /// P119 : post not belong to current contest
  /// </summary>
  static const String postNotBelongInCurrentContest = "P119";

  /// <summary>
  /// CT111 : contest not found
  /// </summary>
  static const String contestNotFound = "CT111";

  /// <summary>
  /// CT112 : Contest name is duplicated
  /// </summary>
  static const String contestNameIsDuplicated = "CT112";

  /// <summary>
  /// CT113 : get list of contest fail
  /// </summary>
  static const String getContestFail = "CT113";

  /// <summary>
  /// CT114 : delete contest fail
  /// </summary>
  static const String deleteContestFail = "CT114";

  /// <summary>
  /// CT115 : add contest fail
  /// </summary>
  static const String addContestFail = "CT115";

  /// <summary>
  /// CT116 : update contest fail
  /// </summary>
  static const String updateContestFail = "CT116";

  /// <summary>
  /// CT117 : No contest to display
  /// </summary>
  static const String noContestToDisplay = "CT117";

  /// <summary>
  /// CT118 : Active contest manually fail
  /// </summary>
  static const String activeContestManuallyFail = "CT118";

  /// <summary>
  /// CT119 : Extend duartion delayed fail
  /// </summary>
  static const String extendDurationDelayedFail = "CT119";

  /// <summary>
  /// CT120 : No user in contest
  /// </summary>
  static const String contestHasNoParticipater = "CT120";

  /// <summary>
  /// CT121 : get user in contest fail
  /// </summary>
  static const String getUserInContestFail = "CT121";

  /// <summary>
  /// CT122 : contest must have prize
  /// </summary>
  static const String contestMustHavePrize = "CT122";

  /// <summary>
  /// JO111 : job id is required to delete it
  /// </summary>
  static const String jobIdRequired = "JO111";

  /// <summary>
  /// CM111 : get comment fail
  /// </summary>
  static const String getCommentFail = "CM111";

  /// <summary>
  /// CM112 : add comment fail
  /// </summary>
  static const String addCommentFail = "CM112";

  /// <summary>
  /// CM113 : comment not found
  /// </summary>
  static const String commentNotFound = "CM113";

  /// <summary>
  /// CM114 : delete commment fail
  /// </summary>
  static const String deleteCommentFail = "CM114";

  /// <summary>
  /// CM115 : no comment to didplay
  /// </summary>
  static const String noCommentToDisplay = "CM115";

  /// <summary>
  /// CM116 : comment not belong to current user
  /// </summary>
  static const String commentNotBelong = "CM116";

  /// <summary>
  /// LK111 : user has liked this post
  /// </summary>
  static const String likeExist = "LK111";

  /// <summary>
  /// LK112 : add like fail
  /// </summary>
  static const String addLikeFail = "LK112";

  /// <summary>
  /// LK113 : like not exist
  /// </summary>
  static const String likeNotExist = "LK113";

  /// <summary>
  /// LK114 : delete like fail
  /// </summary>
  static const String deleteLikeFail = "LK114";

  /// <summary>
  /// FL111 : user has followed this user
  /// </summary>
  static const String followExist = "FL111";

  /// <summary>
  /// FL112 : add follow fail
  /// </summary>
  static const String addFollowFail = "FL112";

  /// <summary>
  /// FL113 : follow not exist
  /// </summary>
  static const String followNotExist = "FL113";

  /// <summary>
  /// FL114 : delete follow fail
  /// </summary>
  static const String deleteFollowFail = "FL114";

  /// <summary>
  /// CC111 : generate confirm code fail
  /// </summary>
  static const String generateConfirmCodeFail = "CC111";

  /// <summary>
  /// CC112 : validate confirm code fail
  /// </summary>
  static const String validateConfirmCodeFail = "CC112";

  /// <summary>
  /// CC113 : regenerate confirm code fail
  /// </summary>
  static const String reGenerateConfirmCodeFail = "CC113";

  /// <summary>
  /// UC111 : user confirm code is not found
  /// </summary>
  static const String codeNotFound = "UC111";

  /// <summary>
  /// UC112 : code is expired
  /// </summary>
  static const String codeIsExpired = "UC112";

  /// <summary>
  /// UC113 : activation fail
  /// </summary>
  static const String activationFail = "UC113";

  /// <summary>
  /// PR111 : post reference exist
  /// </summary>
  static const String postReferenceExist = "PR111";

  /// <summary>
  /// PR112 : add post reference fail
  /// </summary>
  static const String addReferencePostFail = "PR112";

  /// <summary>
  /// PR113 : user want to save their own post
  /// </summary>
  static const String postReferenceBelongtoRequestUser = "PR113";

  /// <summary>
  /// RP111 : add report fail
  /// </summary>
  static const String addReportFail = "RP111";

  /// <summary>
  /// RP112 : no report available
  /// </summary>
  static const String noReportAvailable = "RP112";

  /// <summary>
  /// RP113 : report delete or not exist
  /// </summary>
  static const String reportNotFound = "RP113";

  /// <summary>
  /// RP114 : update report fail
  /// </summary>
  static const String updateReportFail = "RP114";

  /// <summary>
  /// RP113 : get report error
  /// </summary>
  static const String getReportError = "RP113";

  /// <summary>
  /// NT111 : no notification to display
  /// </summary>
  static const String noNotificationToDisplay = "NT111";

  /// <summary>
  /// NT112 : get notification fail
  /// </summary>
  static const String getNotificationFail = "NT112";

  /// <summary>
  /// NT113 : add notification fail
  /// </summary>
  static const String addNotificationFail = "NT113";

  /// <summary>
  /// B112 : book is deleted
  /// </summary>
  static const String bookDelete = "B112";

  /// <summary>
  /// B113 : get book fail
  /// </summary>
  static const String getBookFail = "B113";

  /// <summary>
  /// B114 : book's author or publisher duplicated
  /// </summary>
  static const String bookInforDuplicated = "B114";

  /// <summary>
  /// S111 : search is failed
  /// </summary>
  static const String searchFail = "S111";

  /// <summary>
  /// S112 : string contain search value is null or white space
  /// </summary>
  static const String stringSearchFail = "S112";

  /// <summary>
  /// S113 : Product Per Page of Current Page is blank or zero
  /// </summary>
  static const String intIsBlank = "S113";

  /// <summary>
  /// TA111 : wrong type or action to enter api
  /// </summary>
  static const String wrongTypeOrAction = "TA111";

  /// <summary>
  /// D111 : date is invalid
  /// </summary>
  static const String wrongFormatForDate = "D111";

  /// <summary>
  /// C111 : get category fail
  /// </summary>
  static const String getCategoryFail = "C111";

  /// <summary>
  /// C112 : category not found or deleted
  /// </summary>
  static const String categoryNotFound = "C112";

  /// <summary>
  /// C113 : update category fail
  /// </summary>
  static const String updateCategoryFail = "C113";

  /// <summary>
  /// C114 : category exist
  /// </summary>
  static const String categoryExist = "C114";

  /// <summary>
  /// C115 : add category fail
  /// </summary>
  static const String addCategoryFail = "C115";

  /// <summary>
  /// CV111 : conversation not found
  /// </summary>
  static const String conversationNotFound = "CV111";

  /// <summary>
  /// CV112 : no conversation to display
  /// </summary>
  static const String noConversationToDisplay = "CV112";

  /// <summary>
  /// CV113 : get conversation fail
  /// </summary>
  static const String getConversationFail = "CV113";

  /// <summary>
  /// MS111 : get message fail
  /// </summary>
  static const String getMessageFail = "MS111";

  /// <summary>
  /// MS112 : No message to display
  /// </summary>
  static const String noMessageToDisplay = "MS112";

  /// <summary>
  /// MS113 : Send message fail
  /// </summary>
  static const String sendMessageFail = "MS113";

  /// <summary>
  /// MS114 : Message not found
  /// </summary>
  static const String messageNotFound = "MS114";

  /// <summary>
  /// MS115 : update message fail
  /// </summary>
  static const String updateMessageFail = "MS115";

  /// <summary>
  /// R111 : Role not found or deleted
  /// </summary>
  static const String roleNotFoundOrDeleted = "R111";

  /// <summary>
  /// DU111 : Duplicated but has been deleted
  /// </summary>
  static const String duplicateButDelete = "DU111";

  /// <summary>
  /// DU112 : Duplicated
  /// </summary>
  static const String duplicate = "DU112";

  /// <summary>
  /// R111 : Add role fail
  /// </summary>
  static const String addRoleFail = "R111";

  /// <summary>
  /// R112 : Update role fail
  /// </summary>
  static const String updateRoleFail = "R112";

  /// <summary>
  /// R113 : role not valid
  /// </summary>
  static const String roleNotValid = "R113";

  /// <summary>
  /// S113 : string contain name value is null or white space
  /// </summary>
  static const String stringNameFail = "S113";

  /// <summary>
  /// F111 : File PDF, Image or watermark name in request is null
  /// </summary>
  static const String fileOrNameIsNull = "F111";

  /// <summary>
  /// SE111 : Send Email Fail
  /// </summary>
  static const String sendEmailFail = "SE111";

  /// <summary>
  /// EM111 : email format not valid
  /// </summary>
  static const String emailFormatInvalid = "EM111";

  /// <summary>
  /// ST111 : Wrong type of status
  /// </summary>
  static const String wrongTypeStatus = "ST111";

  /// <summary>
  /// TK111 : Jwt token is not expired
  /// </summary>
  static const String tokenIsNotExpired = "TK111";

  /// <summary>
  /// TK112 : refresh token is not existed
  /// </summary>
  static const String refreshTokenNotExisted = "TK112";

  /// <summary>
  /// TK113 : token expired
  /// </summary>
  static const String tokenExpired = "TK113";

  /// <summary>
  /// TK114 : token role not valid
  /// </summary>
  static const String tokenRoleNotValid = "TK114";

  /// <summary>
  /// TK115 : refresh token expired
  /// </summary>
  static const String refreshTokenExpired = "TK115";

  /// <summary>
  /// TK116 : jwt token not match refresh token
  /// </summary>
  static const String jwtTokenNotMatchRefreshToken = "TK116";

  /// <summary>
  /// TK117 : refresh token fail
  /// </summary>
  static const String refreshTokenFail = "TK117";

  /// <summary>
  /// TK118 : generate new jwt token fail
  /// </summary>
  static const String generateNewTokenFail = "TK118";

  /// <summary>
  /// TK119 : refresh token not found
  /// </summary>
  static const String tokenNotFound = "TK119";

  /// <summary>
  /// TK120 : delete refresh token fail
  /// </summary>
  static const String deleteTokenFail = "TK120";

  /// <summary>
  /// TK121 : token invalid
  /// </summary>
  static const String tokenInvalid = "TK121";

  /// <summary>
  /// LG111 : login fail
  /// </summary>
  static const String loginFail = "LG111";

  /// <summary>
  /// FO111 : force logout fail
  /// </summary>
  static const String forceLogoutFail = "FO111";

  /// <summary>
  /// HS111 : add search user to history fail
  /// </summary>
  static const String addUserToHistoryFail = "HS111";

  /// <summary>
  /// HS112 : user not found in history
  /// </summary>
  static const String historyNotFound = "HS112";

  /// <summary>
  /// HS113 : Delete search history fail
  /// </summary>
  static const String deleteSearchHistoryFail = "HS113";

  /// <summary>
  /// HS114 : No search history to display
  /// </summary>
  static const String noSearchHistoryToDisplay = "HS114";

  /// <summary>
  /// HS115 : Get search history fail
  /// </summary>
  static const String getSearchHistoryFail = "HS115";

  /// <summary>
  /// HS116 : Get more search history fail
  /// </summary>
  static const String getMoreSearchHistoryFail = "HS116";

  /// <summary>
  /// W111 : Calculate weight fail
  /// </summary>
  static const String calculateWeightFail = "W111";

  /// <summary>
  /// P120 : In single contest user can not post more than 1 post
  /// </summary>
  static const String duplicatePostInContest = "P120";

  /// <summary>
  /// U130 : user has been block by admin
  /// </summary>
  static const String userIsBlock = "U130";

  /// <summary>
  /// PZ111 : add prize fail
  /// </summary>
  static const String addPrizeFail = "PZ111";

  /// <summary>
  /// PZ112 : prize name is duplicated
  /// </summary>
  static const String prizeNameIsDuplicated = "PZ112";

  /// <summary>
  /// PZ113 : prize not found
  /// </summary>
  static const String prizeNotFound = "PZ113";

  /// <summary>
  /// PZ114 : prize is used in existed contest
  /// </summary>
  static const String prizeIsUsedInExistedContest = "PZ114";

  /// <summary>
  /// PZ115 : update prize fail
  /// </summary>
  static const String updatePrizeFail = "PZ115";

  /// <summary>
  /// PZ116 : no prize to display
  /// </summary>
  static const String noPrizeToDisplay = "PZ116";

  /// <summary>
  /// PZ117 : get prize fail
  /// </summary>
  static const String getPrizeFail = "PZ117";

  /// <summary>
  /// RP116 : post is already reported
  /// </summary>
  static const String reportExist = "RP116";

  /// <summary>
  /// AI111 : AI server is inactive
  /// </summary>
  static const String aiIsNotActive = "AI111";

  /// <summary>
  /// ALB118 : There is still post in album
  /// </summary>
  static const String stillPostInDeletedAlbum = "ALB118";

  /// <summary>
  /// CT124 : Contest has been closed
  /// </summary>
  static const String contestHasBeenClosed = "CT124";
}
