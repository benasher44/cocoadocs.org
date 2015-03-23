#!/usr/bin/env ruby

require 'rubygems'
require 'httparty'
require 'timeout'


def post_numbers (number)
  api_key = ENV['STATUS_IO_API_KEY']
  page_id = ENV['STATUS_IO_PAGE_ID']
  metric_id = ENV['STATUS_IO_METRIC_ID']
  api_base = 'https://api.statuspage.io/v1'
 
  dhash = {
    :timestamp => Time.now.to_i,
    :value => number
  }
  HTTParty.post("#{api_base}/pages/#{page_id}/metrics/#{metric_id}/data.json",  :headers => { 'Authorization' => "OAuth #{api_key}" }, :body => { :data => dhash } )
end 

loop do
  begin
    Timeout::timeout(5 * 60) do
      number = HTTParty.get "http://localhost:4567/recent_pods_count"
      puts "Sending #{number} pods to Status.io"
      post_numbers number.to_i
    end
  rescue Timeout::Error
    puts "We were not able to reach StatusPage.io in time."
  # rescue StandardError # StandardError is not rescued.
  end
end
