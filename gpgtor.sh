#!/usr/bin/env bash
#=========================HEADER==============================================|
#AUTHOR
# Jefferson 'Slackjeff' Rocha <root@slackjeff.com.br>
#
# Simple program for newbiews in gpg
#
#=============================================================================|


#=============================== FUNCTIONS
_HOW_TO()
{
		cat <<EOF | less
HOW SIGNATURE A KEY?
--------------------

* Select '6' for import key on the server
* Select '0' for Sign the key
* Select OPTION '4' for Export a Key to external archive
* Select OPTION  '5' to Send Key for Server

EOF
}
_ENTER()
{
		read -p $'\e[31;1mPRESS [ENTER] TO CONTINUE\e[m'
		clear
		return 0
}
_LIST_KEY()
{
		echo -e "-----> Key List.\n"
		gpg --list-keys && return 0
}

_LIST_SIGNATURES()
{
		echo -e "-----> Signature List.\n"
		gpg --list-signatures && return 0
}

_SIGN_KEY()
{
		local fingerprint

    echo -e "-----> SIGN KEY\n"
 		read -ep "Say FINGERPRINT for SIGN KEY: " fingerprint
    if [[ -n "$fingerprint" ]]; then
 				fingerprint="${fingerprint// /}"
    		gpg --sign-key "$fingerprint"
    fi
}

_IMPORT_LOCAL_KEY()
{
    echo -e "-----> IMPORT LOCAL KEY\n"
  	read -ep "ARCHIVE FOR IMPORT: " archive
    if [[ -n "$archive" ]] && [[ -e "$archive" ]]; then
  			gpg --import "$archive"
  			return 0
  	else
  			echo "Archive '$archive' don't exist."
  			return 1
		fi
}

_EXPORT_LOCAL_KEY()
{
		local fingerprint
		local ascrandom="$RANDOM"

    echo -e "-----> EXPORT LOCAL KEY\n"
  	read -ep "FINGERPRINT FOR EXPORT: " fingerprint
    if [[ -n "$fingerprint" ]]; then
  			gpg -a --export "$fingerprint" > "${ascrandom}.asc"
	  	  echo "'${fingerprint}' EXPORTED to archive '${ascrandom}.asc' in $PWD"
    fi
}

_SEND_KEY_SERVER()
{
		local server="pgp.mit.edu"
		local fingerprint

  	echo -e "-----> Send Key to Server\n"
		read -p "SAY FINGERPRINT FOR SEND TO SERVER: " fingerprint
    if [[ -n "$fingerprint" ]]; then
		    gpg --keyserver "$server" --send-keys "$fingerprint"
	  fi
}

_IMPORT_KEY_TO_SERVER()
{
		local server="pgp.mit.edu"
		local fingerprint

    echo -e "-----> Import Key Server for your Local Keychain.\n"
 	  read -p "SAY FINGERPRINT FOR IMPORT SERVER: " fingerprint
	  if [[ -n "$fingerprint" ]]; then
				gpg --keyserver "$server" --receive-keys "$fingerprint"
    fi
}


_LOGO()
{
		cat <<'EOF'
ad8888888888ba
dP'         `"8b,
8  ,aaa,       "Y888a     ,aaaa,     ,aaa,  ,aa,
8  8' `8           "88baadP""""YbaaadP"""YbdP""Yb
8  8   8              """        """      ""    8b
8  8, ,8         ,aaaaaaaaaaaaaaaaaaaaaaaaddddd88P
8  `"""'       ,d8""
Yb,         ,ad8"    G P G T O R
 "Y8888888888P"

----------------------------------------------------------
EOF
}

#=============================== MAIN
MENU=(
		'SIGN KEY'
		'LIST KEY'
		'LIST KEYS SIGNATURE'
		'IMPORT LOCAL KEY'
		'EXPORT LOCAL KEY TO ARCHIVE'
		'SEND KEY TO SERVER *pgp.mit.edu*'
		'IMPORT KEY SERVER'
)
_LOGO # call logo

while true; do
	  i='0' # up up up
		# Generate Menu
		for menu in "${MENU[@]}"; do
			  echo -e "\t[ \e[31;1m${i}\e[m ] $menu"
				i=$(($i + 1))
		done
		read -ep $'\nCHOICE> ' user_choice
		case $user_choice in
				0) _SIGN_KEY ;;
				1) _LIST_KEY ;;
				2) _LIST_SIGNATURES ;;
				3) _IMPORT_LOCAL_KEY ;;
				4) _EXPORT_LOCAL_KEY ;;
				5) _SEND_KEY_SERVER ;;
				6) _IMPORT_KEY_TO_SERVER ;;
		esac
		_ENTER
done
