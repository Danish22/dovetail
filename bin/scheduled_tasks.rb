#
# Add scheduled jobs to to be run here.
#
# Runs like so: bundle exec rails runner bin/scheduled_tasks.rb
#
require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

# Run the generate invoices task at 2am everyday (Server time, UTC)
scheduler.cron '00 02 * * *' do
  # Generate invoices for subscriptions that are renewing today goes here.
  Space.generate_subscription_invoices
end

# Run the process subscription payments task at 4am everyday (Server time, UTC)
# (So the generate invoices has time to complete)
scheduler.cron '00 04 * * *' do
  # Process payments that are due today goes here.
  Space.process_subscription_payments
end

# let the current thread join the scheduler thread
scheduler.join
