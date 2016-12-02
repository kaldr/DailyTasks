import {Meteor} from 'meteor/meteor'
import {Parties} from './collection.coffee'
import { Counts } from 'meteor/tmeasday:publish-counts'
if Meteor.isServer
  Meteor.publish 'parties', (options, searchString) ->
    selector =
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
              owner: @userId
            }
            {
              owner:
                $exists: true
            }
          ]
        }
      ]

    if typeof searchString == 'string' and searchString.length
      selector.name =
        $regex: ".*#{searchString}.*"
        $options: 'i'

    Counts.publish(this, 'numberOfParties', Parties.find(selector), {noReady: true} )
    Parties.find selector, options
