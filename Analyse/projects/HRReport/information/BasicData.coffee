Q = require 'q'
CSON = require 'cson'
{CollectionDictionary} = require './collectionDictionary'

{Industry} = require "./industry"
{Domain} = require './domain'

{Profession} = require './profession'
{ProfessionDomain} = require './professionDomain'

class BasicData
	constructor: (@dbname = 'localhost') ->
		@Domain = new Domain @dbname
		@Industry = new Industry @dbname
		@CollectionDictionary = new CollectionDictionary @dbname
		@Profession = new Profession @dbname
		@ProfessionDomain = new ProfessionDomain @dbname

	generateBasicData: (closeDB = false) =>
		Q.all [
				@Profession.updateProfession()
					.then @ProfessionDomain.updateProfessionDomain
					.then @Profession.updateProfessionType
        @CollectionDictionary.updateCollectionDictionary()
				@Industry.updateIndustry()
					.then @Domain.updateDomain
					.then @Industry.updateIndustryDomainItem
				]
    		.then () =>
					if closeDB
						Q.all [
							@Domain.closeDB()
							@Industry.closeDB()
							@CollectionDictionary.closeDB()
							@Profession.closeDB()
							@ProfessionDomain.closeDB()
						]
					console.log "\n🍺 All tasks done."

exports.BasicData = BasicData
