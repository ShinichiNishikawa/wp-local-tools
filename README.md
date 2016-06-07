# WordPress Local Tools

This is a toolkit to make your WordPress life a lot easier, meant to be used on a local machine. Let's automate installing WordPress, creating remote backups, starting coding themes with gulp, all by one command.

[日本語の readme はこちら](https://github.com/ShinichiNishikawa/wp-local-tools/blob/master/README-ja.md)

## Requirements

The scripts here requires the following tools.

- [Command line interface for WordPress | WP-CLI](http://wp-cli.org/)
- [welaika/wordmove: Capistrano for Wordpress](https://github.com/welaika/wordmove)
- [Git](https://git-scm.com/)

## Tools

### WP Backup

This is useful when you create a backup of a project from your remote, and update all on your local machine.

Run in a working WordPress project directory, this script

- creates a folder, `~/Dropbox/Backups/{pwd}/{time}/`,
- dumps local database backup in the foloder,
- pulls WordPress core, themes, plugins, medias, and all the other files from your remote server ( it's a quick rsync ),
- pulls the remote database and downloads/imports it into local database, and search remote domain name / replace to local domain name,
- logs all the work this script does into `log-{pwd}-{time}.txt` file in the folder in the folder,
- creates a report email body, which you can copy/paste/send to your client.

### WP init

This will set up a whole new WordPress.

Run in a folder to create a new WordPress project, this script

- downloads the newest WordPress software,
- creates wp-config.php, 
- creates database, 
- set WP_DEBUG to true,
- downloads Movefile for Wordmove, wp-cli.local.yml for wp-cli, and .gitignore for Git.

### Theme init

Create a gulp environment for your theme development with this comment.

Run in a theme folder, this script

- sets up a theme coding environment, which includes
  - sass
  - auto prefixer
  - browser sync
  - sass source map
- serves the site locally 
- watch almost all the changes in your theme directory and reloads your browser

## How to use

`git clone` this repository and make them executable in your machine.
