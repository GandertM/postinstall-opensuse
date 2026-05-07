#!/usr/bin/env bash

#
# user-c-configs.sh
#

# ~~~~~~~~~~~~~~~~~~~~~~~~~~  ~~~~~~~~~~~~~~~~~~~~~~~~~~

create_directories() {
	# required for k
	DIR_LIST=(
		".config/fastfetch"
		".config/mc"
		".config/starship"
		".config/zsh"
		# ".crd"
		# ".ssh"
		# "bin"
		# "encrypted"
		# "journals"
		"data-on-nas"
		# "notes"
		# "projects"
		# "restores"
		# "virtmachs"
	)

	# goto $HOME
	cd "$HOME" || return

	# actual creation
	for DIR in "${DIR_LIST[@]}"; do

		if [[ -d "$DIR" ]]; then
			log_message "INFO" "$DIR exists, skipping creation."
		else
			log_message "INFO" "Creating $DIR..."

			mkdir -p "$DIR"

			if test $? -eq 0; then
				log_message "CREATE" "$DIR created successfully."
			else
				log_message "ERROR" "Failed to create $DIR."
				exit 1
			fi
		fi

	done

}

install_meslo() {
	log_message "-------" "Install font."

	# Install font 'MesloLGSDZ Nerd Font 13pt' of 'MesloLGS Nerd Font Mono'
	FONT_NAME="Meslo Nerd Font"
	FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
	FONT_DIR="$HOME/.local/share/fonts"
	FONT_CHCK="$FONT_DIR"/"$FONT_NAME"

	#if fc-list :family | grep -iq "$FONT_NAME"; then
	if [[ -d "$FONT_CHCK" ]]; then

		log_message "INFO" "Font '$FONT_NAME' is installed."

	else

		log_message "INFO" "Installing font '$FONT_NAME'"

		# check if the file is accessible
		if wget -q --spider "$FONT_URL"; then
			TEMP_DIR=$(mktemp -d)
			wget -q --show-progress $FONT_URL -O "$TEMP_DIR"/"${FONT_NAME}".zip
			unzip "$TEMP_DIR"/"${FONT_NAME}".zip -d "$TEMP_DIR"
			mkdir -p "$FONT_DIR"/"$FONT_NAME"
			mv "${TEMP_DIR}"/*.ttf "$FONT_DIR"/"$FONT_NAME"

			# Update the font cache
			fc-cache -fv

			# Delete the files created from this
			rm -rf "${TEMP_DIR}"
			log_message "INFO" "'$FONT_NAME' installed successfully."
		else
			log_message "ERROR" "Font '$FONT_NAME' not installed. Font URL is not accessible."
		fi
	fi
}

install_firacode() {
	log_message "-------" "Install font."

	# Install font 'FiraCode Nerd Font'
	FONT_NAME="FiraCode Nerd Font"
	FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
	FONT_DIR="$HOME/.local/share/fonts"
	FONT_CHCK="$FONT_DIR"/"$FONT_NAME"

	#if fc-list :family | grep -iq "$FONT_NAME"; then
	if [[ -d "$FONT_CHCK" ]]; then
	
		log_message "INFO" "Font '$FONT_NAME' is installed."

	else

		log_message "INFO" "Installing font '$FONT_NAME'"

		# check if the file is accessible
		if wget -q --spider "$FONT_URL"; then
			TEMP_DIR=$(mktemp -d)
			wget -q --show-progress $FONT_URL -O "$TEMP_DIR"/"${FONT_NAME}".zip
			unzip "$TEMP_DIR"/"${FONT_NAME}".zip -d "$TEMP_DIR"
			mkdir -p "$FONT_DIR"/"$FONT_NAME"
			mv "${TEMP_DIR}"/*.ttf "$FONT_DIR"/"$FONT_NAME"

			# Update the font cache
			fc-cache -fv

			# Delete the files created from this
			rm -rf "${TEMP_DIR}"
			log_message "INFO" "'$FONT_NAME' installed successfully."
		else
			log_message "ERROR" "Font '$FONT_NAME' not installed. Font URL is not accessible."
		fi
	fi
}

# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip

install_jetbrainsmono() {
	log_message "-------" "Install font."

	# Set font to 'JetBrainsMono Nerd Font'
	FONT_NAME="JetBrainsMono Nerd Font"
	FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
	FONT_DIR="$HOME/.local/share/fonts"
	FONT_CHCK="$FONT_DIR"/"$FONT_NAME"

	#if fc-list :family | grep -iq "$FONT_NAME"; then
	if [[ -d "$FONT_CHCK" ]]; then

		log_message "INFO" "Font '$FONT_NAME' is installed."

	else

		log_message "INFO" "Installing font '$FONT_NAME'"

		# check if the file is accessible
		if wget -q --spider "$FONT_URL"; then
			TEMP_DIR=$(mktemp -d)
			wget -q --show-progress $FONT_URL -O "$TEMP_DIR"/"${FONT_NAME}".zip
			unzip "$TEMP_DIR"/"${FONT_NAME}".zip -d "$TEMP_DIR"
			mkdir -p "$FONT_DIR"/"$FONT_NAME"
			mv "${TEMP_DIR}"/*.ttf "$FONT_DIR"/"$FONT_NAME"

			# Update the font cache
			fc-cache -fv

			# Delete the files created from this
			rm -rf "${TEMP_DIR}"
			log_message "INFO" "'$FONT_NAME' installed successfully."
		else
			log_message "ERROR" "Font '$FONT_NAME' not installed. Font URL is not accessible."
		fi
	fi
}

install_dotfiles() {
	log_message "-------" "Install projects."
	local DIR_DOTS="$HOME/.dotfiles"

	cd "$HOME" || return

	if [[ ! -d "$DIR_DOTS" ]]; then

		mkdir -p "$DIR_DOTS"

		git clone https://github.com/GandertM/dotfiles.git "$DIR_DOTS"

		if test $? -eq 0; then
			log_message "INFO" "Dotfiles cloned successfully."
		else
			log_message "ERROR" "Dotfiles not cloned."
			exit 1
		fi

	else

		log_message "INFO" "Config files already installed."

	fi

}

stow_dotfiles() {
	log_message "-------" "Stow dotfiles."
	local DIR_DOTS="$HOME/.dotfiles"

	# stow dotfiles from list
	STOW_LIST=(
		"fastfetch"
		"mc"
		"starship"
		"zsh"
		"vim"
	)

	if [[ -d "$DIR_DOTS" ]]; then

		cd "$DIR_DOTS" || return

		# actual stowing
		for APP in "${STOW_LIST[@]}"; do

			log_message "INFO" "Stowing $APP..."

			stow "$APP"

			if test $? -eq 0; then
				log_message "INFO" "$APP stowed successfully."
			else
				log_message "ERROR" "$APP not stowed."
				exit 1
			fi

		done

	else

		log_message "INFO" "Config files directory not present."

	fi

	cd "$HOME" || return
}

link_mounts() {
	log_message "-------" "Link mounts."
	local DIR_LINKS="$HOME/data-on-nas"

	cd "$HOME" || return

	if [[ ! -d "$DIR_LINKS" ]]; then

		mkdir -p "$DIR_LINKS"

		ln -s /mnt/nas/backup ~/data-on-nas/backup ||  log_message "ERROR" "Link backup not succesfull."
		# ln -s /mnt/nas/film ~/data-on-nas/film ||  log_message "ERROR" "Link film not succesfull."
		ln -s /mnt/nas/foto ~/data-on-nas/foto ||  log_message "ERROR" "Link foto not succesfull."
		ln -s /mnt/nas/gedeeld ~/data-on-nas/gedeeld ||  log_message "ERROR" "Link gedeeld not succesfull."
		ln -s /mnt/nas/homenas ~/data-on-nas/homenas ||  log_message "ERROR" "Link homenas not succesfull."
		ln -s /mnt/nas/kluis ~/data-on-nas/kluis ||  log_message "ERROR" "Link kluis not succesfull."
		ln -s /mnt/nas/muziek ~/data-on-nas/muziek ||  log_message "ERROR" "Link muziek not succesfull."
		# ln -s /mnt/nas/muziekarchief ~/data-on-nas/muziekarchief ||  log_message "ERROR" "Link muziekarchief not succesfull."
		# ln -s /mnt/nas/dl-diskst ~/data-on-nas/dl-diskst ||  log_message "ERROR" "Link dl-diskst not succesfull."
		# ln -s /mnt/nas/dl-bckupst ~/data-on-nas/dl-bckupst ||  log_message "ERROR" "Link dl-bckupst not succesfull."
		# ln -s /mnt/nas/homewrk ~/data-on-nas/homewrk ||  log_message "ERROR" "Link homewrk not succesfull."

	else

		log_message "INFO" "Links for mounts already set."

	fi

}

install_ollama() {
	log_message "-------" "Install Ollama."

	# Download and install
	curl -fsSL https://ollama.com/install.sh | sh

	if test $? -eq 0; then
		log_message "INFO" "Ollama installed successfully."
	else
		log_message "ERROR" "Ollama not installed."
		exit 1
	fi

}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ End ~~~~~~~~~~~~~~~~~~~~~~~~~~
