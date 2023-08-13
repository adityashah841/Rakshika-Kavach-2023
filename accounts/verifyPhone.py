import os
from twilio.rest import Client
from twilio.base.exceptions import TwilioRestException
from decouple import config

client = Client(config('TWILIO_ACCOUNT_SID'), config('TWILIO_AUTH_TOKEN'))
verify = client.verify.services(config('TWILIO_VERIFY_SERVICE_SID'))


def send(phone):
    verify.verifications.create(to=phone, channel='sms')
    # print(verification.sid)

def check(phone, code):
    try:
        result = verify.verification_checks.create(to=phone, code=code)
    except TwilioRestException:
        print('no')
        return False
    return result.status == 'approved'




# Custom messages

# x = 1
# if x:
#     print(x)
#     account_sid = config('TWILIO_ACCOUNT_SID')
#     auth_token = config('TWILIO_AUTH_TOKEN')
#     client = Client(account_sid, auth_token)

#     message = client.messages.create(
#                                 body='1.Take a prenatal vitamin 2.Exercise regularly 3.Write a birth plan 4.Educate yourself 5.Change your chores',
#                                 from_='+14322863378',
#                                 to = number
#                             )
#     print(message.sid)