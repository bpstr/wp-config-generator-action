#!/bin/sh

NC="\e[39m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[93m"
CYAN="\e[96m"
DIR="."
SETUP_CHECK="true"
SALTS_LEN="64"
TAB_PREFIX="wp_"
PWD=$(pwd)

needCommand () {
	if [ -x "$(command -v "$1")"  ]
	then
		echo "[$GREEN OK $NC] $1"
	else
		SETUP_CHECK="false"
		echo "[$RED ERROR $NC] $1 is needed, please make sure to install it."
	fi
}

needEnv () {
	if [ -z "$1" ]
	then
		SETUP_CHECK="false"
 		echo "[$RED ERROR $NC] Please set $2 environment variable."
	else
		echo "[$GREEN OK $NC] $2"
	fi
}

needCommand "openssl"
needEnv "$DB_HOST" "DB_HOST"
needEnv "$DB_NAME" "DB_NAME"
needEnv "$DB_USER" "DB_USER"
needEnv "$DB_PASS" "DB_PASS"

if [ -z "$TABLE_PREFIX" ]
then
	echo "[$CYAN INFO $NC] TABLE_PREFIX: Using default value. ($TAB_PREFIX)"
else
	TAB_PREFIX=$TABLE_PREFIX
	echo "[$GREEN OK $NC] TABLE_PREFIX"
fi

if [ -z "$SALTS_SIZE" ]
then
	echo "[$CYAN INFO $NC] SALTS_SIZE: Using default value. ($SALTS_LEN)"
else
	if [ "$SALTS_SIZE" -lt "64" ]
	then
		echo "[$RED ERROR $NC] SALTS_SIZE should be equal or greater than "$SALTS_LEN"."
		SETUP_CHECK="false"
	else 
		SALTS_LEN=$SALTS_SIZE
		echo "[$GREEN OK $NC] SALTS_SIZE"
	fi
fi

if [ "$1" != "" ]
then
	if [ -d "$1" ]
	then
		DIR="$1"
	else
		echo "[$YELLOW WARNING $NC] Path provided ("$1") doesn't exist (Using "$DIR")"
	fi
fi

AUTH_KEY="$(openssl rand -base64 "$SALTS_LEN")"
SECURE_AUTH_KEY="$(openssl rand -base64 "$SALTS_LEN")"
LOGGED_IN_KEY="$(openssl rand -base64 "$SALTS_LEN")"
NONCE_KEY="$(openssl rand -base64 "$SALTS_LEN")"
AUTH_SALT="$(openssl rand -base64 "$SALTS_LEN")"
SECURE_AUTH_SALT="$(openssl rand -base64 "$SALTS_LEN")"
LOGGED_IN_SALT="$(openssl rand -base64 "$SALTS_LEN")"
NONCE_SALT="$(openssl rand -base64 "$SALTS_LEN")"

if [ "$SETUP_CHECK" = "true" ]
then
	echo "<?php
/*************************************************
 * FILE GENERATED By                             *
 * https://github.com/romslf/wp-config-generator *
 *************************************************/

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', '$DB_NAME' );

/** MySQL database username */
define( 'DB_USER', '$DB_USER' );

/** MySQL database password */
define( 'DB_PASSWORD', '$DB_PASS' );

/** MySQL hostname */
define( 'DB_HOST', '$DB_HOST' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY', '$AUTH_KEY' );
define( 'SECURE_AUTH_KEY', '$SECURE_AUTH_KEY' );
define( 'LOGGED_IN_KEY', '$LOGGED_IN_KEY' );
define( 'NONCE_KEY', '$NONCE_KEY' );
define( 'AUTH_SALT', '$AUTH_SALT' );
define( 'SECURE_AUTH_SALT', '$SECURE_AUTH_SALT' );
define( 'LOGGED_IN_SALT', '$LOGGED_IN_SALT' );
define( 'NONCE_SALT', '$NONCE_SALT' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
\$table_prefix = '$TAB_PREFIX';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';" > "$DIR"/wp-config.php && echo "$GREEN""Config generated. (Here: "$DIR"/wp-config.php)"
else
	echo "$RED""Please fix above errors before running me again."
fi