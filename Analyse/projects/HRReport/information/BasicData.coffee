Q = require 'q'
{collectionDictionary} = require './collectionDictionary'

{industry} = require "./industry"
{domain} = require './domain'

{profession} = require './profession'
{professionDomain} = require './professionDomain'

class BasicData
	constructor: (@dbname = 'localhost') ->
		@domain = new domain @dbname
		@industry = new industry @dbname
		@collectionDictionary = new collectionDictionary @dbname
		@profession = new profession @dbname
		@professionDomain = new professionDomain @dbname

	generateBasicData: (closeDB = false) =>
      Q.all [
        @collectionDictionary.updateCollectionDictionary()
        @industry.updateIndustry()
        @profession.updateProfession()
      ]
        .then () =>
          Q.all [
            @domain.updateDomain()
            @professionDomain.updateProfessionDomain()
          ]
        .then @industry.updateIndustryDomainItem
        .then @profession.updateProfessionType
        .done () =>
          if closeDB
						Q.all[
							@domain.closeDB()
							@industry.closeDB()
							@collectionDictionary.closeDB()
							@profession.closeDB()
							@professionDomain.closeDB()
							]
					console.log "\n🍺 All tasks done."

exports.BasicData = BasicData
