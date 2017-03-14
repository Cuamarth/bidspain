
scheduler = Rufus::Scheduler.start_new

scheduler.every("30s") do
   BidHelper.check_bids_end
end 