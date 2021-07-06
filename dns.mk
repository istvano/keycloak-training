.PHONY: dns/create
dns/insert: ##@dns Create host dns entries
	@echo "Creating HOST DNS entries for the project ..."
	@for v in $(DOMAINS) ; do \
		echo $$v; \
		sudo sh -c "sed -zi \"/$$v/!s/$$/\n$(IP_ADDRESS)	$$v/\" /etc/hosts "; \
	done

.PHONY: dns/remove
dns/remove: ##@dns Delete added host dns entries
	@echo "Removing HOST DNS entries ..."
	@for v in $(DOMAINS) ; do \
		echo $$v; \
		sudo sh -c "sed -i \"/$(IP_ADDRESS)	$$v/d\" /etc/hosts"; \
	done