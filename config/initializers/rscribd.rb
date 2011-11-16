require 'rscribd'

Scribd::API.instance.key = 'redacted'
Scribd::API.instance.secret = 'redacted'
Scribd::User.login 'redacted', 'redacted'