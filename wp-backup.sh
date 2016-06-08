#!/usr/bin/env bash
set -ex

# exit if wp-cli, wordmove or git is not installed.
type wp >/dev/null 2>&1 || { echo >&2 "wp-cli is not installed.  Aborting."; exit 1; }
type wordmove >/dev/null 2>&1 || { echo >&2 "Wordmove is not installed.  Aborting."; exit 1; }
type git >/dev/null 2>&1 || { echo >&2 "git is not installed.  Aborting."; exit 1; }


# Variables.
URL_LOCAL=$(wp option get home)
NOW=$(date +%Y-%m-%d-%I)
DIRNAME=${PWD##*/}
NAMEBASE="${DIRNAME}-${NOW}"
SQLNAME="backup-${NAMEBASE}"
SQL_OLD_LOCAL="${SQLNAME}.old.local.sql"
SQL_OLD_REMOTE="${SQLNAME}.old.remote.sql"
SQL_NEW="${SQLNAME}.new.sql"
LOGNAME="log-${NAMEBASE}.txt"
CORE_OLD=$(wp core version)
PLUGINS_OLD=$(wp plugin list --format=table)


# Create directories
if [ ! -e ${HOME}/Dropbox ]; then
  echo "Dropbox doesn't exist."
  exit 1
fi

if [ ! -e ${HOME}/Dropbox/Backups ]; then
  mkdir ${HOME}/Dropbox/Backups
fi

DEST_TEMP="${HOME}/Dropbox/Backups/${DIRNAME}"

if [ ! -e ${DEST_TEMP} ]; then
  mkdir ${DEST_TEMP}
fi

DEST=${DEST_TEMP}/${NOW}

if [ ! -e ${DEST} ]; then
  mkdir ${DEST}
fi


#create old backup
wp db export $SQL_OLD_LOCAL
if [ $? -eq 0 ];then
  mv $SQL_OLD_LOCAL ${DEST}
  echo "wp db export $SQL_OLD_LOCAL success. See Dropbox/Backup/."
else
  echo "Failed to create old local sql dump file. Aborting."
  exit 1;
fi

open ${DEST}

# Log start

WPOUTPUT=$(cat << EOC


============ Job in `echo ${NOW}` start! ============

=== Running wordmove pull -all: ===
`wordmove pull --all`

=== Creating dump file of the remote: ===
`wp db export ${SQL_OLD_REMOTE}`
`mv ${SQL_OLD_REMOTE} ${DEST}`

=== WP Core Version Before Updating: ===
`CORE_OLD=$(wp core version)`
`wp core version`

=== WP Plugin List Before Updating: ===
`wp plugin list --format=table`

=== Running wp core update: ===
`wp core update`

=== Running wp plugin update --all: ===
`wp plugin update --all`

=== WP Core Version After Updating: ===
`wp core version`

=== WP Plugin List After Updating: ===
`wp plugin list --format=table`

=== Git status here: ===
`git status -s`


============ Job in `echo ${NOW}` end! ============


EOC
)

echo "$WPOUTPUT" >> log-temp.txt

cat log-temp.txt | sed -e 's/sshpass -p.* ssh/sshpass -p hidden-for-security ssh/g' | sed -e 's/--password=.* /--password=hidden-for-security /g'  > log.txt
mv log.txt ${DEST}/${LOGNAME}
rm -f log-temp.txt

echo "Upgrading and Logging done. See ${DEST}."


# Email body start
MAILOUTPUTJA=$(cat << EOM

いつもお世話になっております。

WordPress サイトの更新をおこないました。
変更の概要は以下のとおりです。

- 作業日: `date +"%Y年%b月%d日"`
- ローカル環境でWordPress のバージョンを `echo ${CORE_OLD}` から `wp core version` にアップグレードしました。
- ローカル環境でWordPress のプラグインを、以下のようにアップデートしました。

`wp plugin list --fields="name,version" --format=table`

- ローカル環境で、アップデートに由来するエラーの有無を確認・修正
- 本番環境に変更を適用
- 本番環境での表示、ログインなどを確認

作業内容の詳細は、別添の ${LOGNAME} にも記載があります。

今後とも引き続きどうぞ宜しくお願い致します。

EOM
)

echo "$MAILOUTPUTJA" > mail-ja.txt

mv mail-ja.txt ${DEST}/mail-ja-${NOW}.txt

# English Email body start
MAILOUTPUTEN=$(cat << EOM

Hi,

I have just updated the WordPress website as below.

- Date: `date +"%d, %b, %Y"`.
- Updated the WordPress core from `echo ${CORE_OLD}` to `wp core version`.
- Updated all the plugins and the versions of them after updating is as below.

`wp plugin list --fields="name,version" --format=table`

- Checked if there are any errors or something that needs fixed.
- Deployed the changes above to the production site.
- Double checked the production website.

The further detail of the work is described in ${LOGNAME}.

Thanks!

EOM
)

echo "$MAILOUTPUTEN" > mail-en.txt

mv mail-en.txt ${DEST}/mail-en-${NOW}.txt

exit 0
