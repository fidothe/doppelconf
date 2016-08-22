Simple demonstration of double-config-loading problem

Run `bundle exec hanami server` and the puts / p statements in the
configuration block in `apps/web/application.rb` will be run twice. The call
stacks show you what's happening...

(See https://github.com/hanami/hanami/issues/643)
