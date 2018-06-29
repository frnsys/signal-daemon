# Signal Daemon

![](shot.png)

Note taking, memos, to-dos, journaling, etc with Signal, built on [`signal-cli`](https://github.com/AsamK/signal-cli).

For awhile I've had trouble finding a good journaling/note-taking system for mobile, mostly because of issues of security/lack of encryption and synchronizing. And most note-taking apps have a lot of extra features that confuse the interface, and sometimes felt too formal; I wanted something that I could easily fire-off notes with, no pressure or anything. Which Signal and its texting interface are great for.

## Usage

Follow the [setup](#setup) directions below, then just start texting your daemon!

You can specify a directive prior to a message to direct it to a specific file, e.g. the message "TODO: hello world" will append to a file called `todo.md` in whatever `OUTPUT_DIR` you specify.

Attachments will be copied over to `OUTPUT_DIR/ASSETS_DIR`.

## Setup

1. Install dependencies
    - `pip install tzlocal`
    - Install [`signal-cli`](https://github.com/AsamK/signal-cli#installation)
2. [Setup your daemon Signal number](#setup-signal-number)
3. Configure the script as needed, e.g. the `OUTPUT_DIR` variable.
4. In some init/system startup script, make sure you export your daemon number as the `DAEMONSIGNALNUM` environment variable.
5. [Setup `crontab` to run regularly](#setup-crontab)

### Setup Signal number

Things get a bit tricky/messy if you use your existing Signal number (i.e. duplicate messages and messages not coming through). I recommend signing up for a separate number elsewhere, e.g. Google Voice.

Once you have that number (e.g. `+1XXXXXXXXXX`), export it as an environment variable and register it with `signal-cli`:

```
export DAEMONSIGNALNUM='+1XXXXXXXXXX'
signal-cli -u ${DAEMONSIGNALNUM} register
```

You should see some instructions for retrieving a verification code, so check e.g. Google Voice (or whatever you used to get the number), and then pass it to `signal-cli`:

```
signal-cli -u ${DAEMONSIGNALNUM} verify XXX-XXX
```

Now you should be able to receive messages sent to that number via `signal-cli`.

In your phone, add that number to your contacts and you can start texting it.

### Setup `crontab`

```
sudo crontab -e

# then add e.g.:
# */15 * * * * /path/to/daemon.py
```

## Bash version

A Bash version is included too (`daemon.sh`), which is simpler than the Python version (it doesn't handle attachments, nor does it support directing memos to specific files).
