const authUserNotFoundMessage = 'User not found';
const authInvalidCredentialsMessage = 'Invalid email or password';
const authEmailAlreadyInUseMessage = 'This email is already registered';
const authInvalidEmailMessage = 'Invalid email';
const authWeakPasswordMessage =
    'Password is too weak (at least 6 characters required)';
const authNoInternetMessage = 'No internet connection';
const authTooManyRequestsMessage = 'Too many attempts. Please try again later';
const authUserNotAuthorizedMessage = 'User is not authorized';

const authSignInFailedMessage = 'Failed to sign in';
const authUnexpectedErrorMessage = 'An error occurred. Please try again.';
const authUserDataFetchFailedMessage = 'Failed to fetch user data';
const authEmailNotVerifiedYetMessage =
    'Email is not verified yet. Please check your inbox.';

String authVerificationEmailSentMessage(String email) =>
    'Verification email was sent to $email';

String authVerificationEmailResentMessage(String email) =>
    'Verification email was resent to $email';
