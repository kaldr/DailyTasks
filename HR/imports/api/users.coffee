import {Meteor} from 'meteor/meteor'

if Meteor.isServer
	Meteor.publish "users", (args) ->
    Meteor.users.find {} , {
      fields:
        emails: 1
        profile: 1
    }
