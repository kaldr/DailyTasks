import _ from 'underscore'
import {Meteor} from 'meteor/meteor'
import {check} from 'meteor/check'
import {Email} from 'meteor/email'

import {Parties} from './collection.coffee'

getContactEmail = (user) ->
  return user.emails[0].address if user.emails && user.emails.length
  return user.services.facebook.email if user.services && user.services.facebook && user.services.facebook.email
  null

rsvp = (partyId, rsvp) =>
  check partyId, String
  check rsvp, String
  console.log
  throw new Meteor.Error 403, 'You must be logged in to RSVP' if not Meteor.userId()
  throw new Meteor.Error 400, "Invalid RSVP" if not _.contains ['yes','no','maybe'], rsvp
  party = Parties.findOne {
    _id: partyId,
    $or: [
      {
        $and: [
          {
            public: true
          }
          {
            public:
              $exists: true
          }
        ]
      }
      {
        $and: [
          {
            owner: Meteor.userId()
          }
          {
            owner:
              $exists: true
          }
        ]
      }
      {
        $and: [
          {
            invited: Meteor.userId()
          }
          {
            invited:
              $exists: true
          }
        ]
      }
    ]
  }

  throw new Meteor.Error 404, 'No such party' if not party
  hasUserRsvp = _.findWhere party.rsvps, {
    user: Meteor.userId()
  }

  if not hasUserRsvp
    Parties.update partyId, {
      $push:
        rsvps:
          rsvp: rsvp
          user: Meteor.userId()
    }
  else
    userId = Meteor.userId()
    Parties.update {
      _id: partyId
      'rsvps.user': userId
    } , {
      $set:
        'rsvps.$.rsvp': rsvp
    }
invite = (partyId, userId) ->
  check partyId, String
  check userId, String
  throw new Meteor.Error 400, 'You have to be logged in!' if not Meteor.userId()
  party = Parties.findOne partyId
  throw new Meteor.Error 404, 'No such party!' if not party
  throw new Meteor.Error 404, 'No permissions!' if party.owner != Meteor.userId()
  throw new Meteor.Error 400, "That party is public. No need to invite people." if party.public

  if userId!=party.owner && ! _.contains party.invited, userId
    Parties.update partyId, {
      $addToSet:
        invited: userId
    }

    replyTo = getContactEmail Meteor.users.findOne Meteor.userId()
    to = getContactEmail Meteor.users.findOne userId

    if Meteor.isServer and to
      Email.send {
        to: to
        replyTo: replyTo
        from: 'noreply@socially.com'
        subject: "PARTY:#{party.title}"
        text: """
            Hey, I just invited you to #{party.title} on Socially.
            Come check it out: #{Meteor.absoluteUrl()}
            """
      }


Meteor.methods {
  invite: invite
  rsvp: rsvp
}

exports.invite = invite
exports.rsvp = rsvp
