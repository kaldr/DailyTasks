import angular from 'angular'

name = 'displayNameFilter'

DisplayNameFilter = (user) ->
  return '' if not user
  return user.profile.name if user.profile && user.profile.name
  return user.emails[0].address if user.emails
  user
filter = angular.module name, []
  .filter name, () =>DisplayNameFilter
  .name

exports.DisplayNameFilter = filter
