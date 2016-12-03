import { Meteor } from 'meteor/meteor';
import { Thumbs, Images } from './collection';

if Meteor.isServer
	Meteor.publish "thumbs", (ids) =>
    Thumbs.find {
      originalStore: 'images'
      originalId:
        $in: ids
    }
  Meteor.publish "images", () =>
    Images.find {}
