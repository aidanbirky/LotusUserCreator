########################################
## Top Brutes Tweeter
## Tweets the top three SSH brute force culprits
## Add the below line to crontab to execute at the end of the month
## 58 23 * * * [ $(date +\%d) -eq $(echo $(cal) | awk '{print $NF}') ] && python /var/log/topbrutes/topbrutes.py
## Written by Aidan
## Last modified 29 December 2015
########################################

import os
import datetime
import tweepy

def get_api(cfg):
    auth = tweepy.OAuthHandler(cfg['consumer_key'], cfg['consumer_secret'])
    auth.set_access_token(cfg['access_token'], cfg['access_token_secret'])
    return tweepy.API(auth)

def main():
    cfg = {
    "consumer_key"        : "paste key here",
    "consumer_secret"     : "paste secret here",
    "access_token"        : "paste token here",
    "access_token_secret" : "paste token secret here"
    }

    date = datetime.date.today()
    strDate = date.strftime('%d%m%y')
    sshfirstDay = date.strftime('%Y' + '-' + '%m' + '-' + '01')
    createMessage = '''echo " Top SSH Brutes @twitterusername" > /var/log/topbrutes/sshtopbrutes{0}'''.format(strDate)
    sshTopBrutes = "journalctl -u sshd --since {0} | grep 'Failed' | grep -o ".format(sshfirstDay) + r"'[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'" + " | sort | uniq -c | sort -urn | head -n 3 >> /var/log/topbrutes/sshtopbrutes{0}".format(strDate)
    os.system(createMessage)
    os.system(sshTopBrutes)
    api = get_api(cfg)
    sshf = open ("/var/log/topbrutes/sshtopbrutes"+strDate, 'r')
    sshtweet = sshf.read()[1:]
    sshstatus = api.update_status(sshtweet)
    sshf.close()

if __name__ == "__main__":
    main()
