SHELL := /bin/bash
 
 
test: ## Run Plasmaviewer to test the plasmoid
	plasmoidviewer -a ./cqcb.plasma.webslice/

locales: ## Run the Messages.sh to compile languages
	./cqcb.plasma.webslice/contents/locale/Messages.sh
	
dl-locales-de: ## Download de strings
	transifex_token=`cat transifex.token`; curl -L --user api:$$transifex_token -X GET "https://www.transifex.com/api/2/project/webslice/resource/cqcbplasmawebslicepot/translation/de/?file" -o cqcb.plasma.webslice/contents/locale/de/LC_MESSAGES/plasma_applet_cqcb.plasma.webslice.po

dl-locales-es: ## Download es strings
	transifex_token=`cat transifex.token`; curl -L --user api:$$transifex_token -X GET "https://www.transifex.com/api/2/project/webslice/resource/cqcbplasmawebslicepot/translation/es/?file" -o cqcb.plasma.webslice/contents/locale/es/LC_MESSAGES/plasma_applet_cqcb.plasma.webslice.po

dl-locales-nl: ## Download nl strings
	transifex_token=`cat transifex.token`; curl -L --user api:$$transifex_token -X GET "https://www.transifex.com/api/2/project/webslice/resource/cqcbplasmawebslicepot/translation/nl/?file" -o cqcb.plasma.webslice/contents/locale/nl/LC_MESSAGES/plasma_applet_cqcb.plasma.webslice.po

dl-locales-ru: ## Download ru strings
	transifex_token=`cat transifex.token`; curl -L --user api:$$transifex_token -X GET "https://www.transifex.com/api/2/project/webslice/resource/cqcbplasmawebslicepot/translation/ru/?file" -o cqcb.plasma.webslice/contents/locale/ru/LC_MESSAGES/plasma_applet_cqcb.plasma.webslice.po

dl-locales-all: dl-locales-de dl-locales-es dl-locales-nl dl-locales-ru ## Download from transifex all the locales

upload-pot: ## Upload the source strings to Transifex
	transifex_token=`cat transifex.token`; curl -i -L --user api:$$transifex_token -F file=@cqcb.plasma.webslice/contents/locale/plasma_applet_cqcb.plasma.webslice.pot -X PUT "https://www.transifex.com/api/2/project/webslice/resource/cqcbplasmawebslicepot/content/" 

upload-locale-fr: ## Upload fr locale to Transifex
	transifex_token=`cat transifex.token`; curl -i -L --user api:$$transifex_token -F file=@cqcb.plasma.webslice/contents/locale/fr/LC_MESSAGES/plasma_applet_cqcb.plasma.webslice.po -X PUT "https://www.transifex.com/api/2/project/webslice/resource/cqcbplasmawebslicepot/translation/fr/"

plasmoid: ## Make the .plasmoid file
	rm -f cqcb.plasma.webslice.plasmoid
	cd ./cqcb.plasma.webslice/; \
	zip -9 -r cqcb.plasma.webslice.plasmoid.zip contents/ metadata.desktop
	mv ./cqcb.plasma.webslice/cqcb.plasma.webslice.plasmoid.zip ./cqcb.plasma.webslice.plasmoid

update: ## Update the installed package
	plasmapkg2 -u cqcb.plasma.webslice.plasmoid

install: ## Install the package if it's not already there
	plasmapkg2 -i cqcb.plasma.webslice.plasmoid

help: ## Help target
	@ag '^[a-zA-Z_-]+:.*?## .*$$' --nofilename $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN{FS=": ## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.DEFAULT_GOAL := help
