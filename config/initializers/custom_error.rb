class BaseCustomError < StandardError; end
class UserIDInvalidError < BaseCustomError; end
class HadBeenFriendError < BaseCustomError; end

