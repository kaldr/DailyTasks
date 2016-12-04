import { Meteor } from 'meteor/meteor';
import { Mongo } from 'meteor/mongo';

Images = new Mongo.Collection 'images'
Thumbs = new Mongo.Collection 'thumbs'

# loggedIn = (userId) =>
#   Meteor.userId()
#
# Thumbs.allow {
#   insert: loggedIn
#   update: loggedIn
#   remove: loggedIn
# }
#
# Images.allow {
#   insert: loggedIn
#   update: loggedIn
#   remove: loggedIn
# }

exports.Images = Images
exports.Thumbs = Thumbs
