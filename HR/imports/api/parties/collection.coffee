import {Mongo} from 'meteor/mongo'
Parties = new Mongo.Collection 'parties'

Parties.allow {
   insert: (userId, party) => userId && party.owner == userId
   update: (userId, party, fields, modifier) =>userId && party.owner == userId
   remove: (userId, party) =>userId && party.owner == userId
}

exports.Parties = Parties
