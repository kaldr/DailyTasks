import angular from 'angular'
name = 'uninvitedFilter'

UninvitedFilter = (users, party) ->
  return false if not party
  users.filter (user) =>
    return user.id != party.owner && (party.invited||[]).indexOf(user._id) == - 1

filter = angular.module name, []
  .filter name, () => UninvitedFilter
  .name

exports.UninvitedFilter = filter
