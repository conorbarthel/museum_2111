require './lib/museum'
require './lib/exhibit'
require './lib/patron'
require 'pry'
RSpec.describe do
  let(:dmns) {Museum.new("Denver Museum of Nature and Science")}
  let(:gems_and_minerals) {Exhibit.new({name: "Gems and Minerals", cost: 0})}
  let(:dead_sea_scrolls) {Exhibit.new({name: "Dead Sea Scrolls", cost: 10})}
  let(:imax) {Exhibit.new({name: "IMAX",cost: 15})}
  let(:patron_1) {Patron.new("Bob", 0)}
  let(:patron_2) {Patron.new("Sally", 20)}
  let(:patron_3) {Patron.new("Johnny", 5)}

  it "exists" do
    expect(dmns).to be_a Museum
  end

  it "has a name" do
    expect(dmns.name).to eq "Denver Museum of Nature and Science"
  end

  it "can have exhibits" do
    expect(dmns.exhibits).to eq([])
  end

  it "can add exhibits" do
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    expect(dmns.exhibits).to eq [gems_and_minerals, dead_sea_scrolls, imax]
  end

  it "can recommend exhibits" do
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    patron_1.add_interest("Dead Sea Scrolls")
    patron_1.add_interest("Gems and Minerals")
    patron_2.add_interest("IMAX")

    expect(dmns.recommend_exhibits(patron_1)).to eq([gems_and_minerals, dead_sea_scrolls])
    expect(dmns.recommend_exhibits(patron_2)).to eq([imax])
  end

  it "can have patrons" do
    expect(dmns.patrons).to eq([])
  end

  it "can admit patrons" do
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    patron_1.add_interest("Dead Sea Scrolls")
    patron_2.add_interest("Dead Sea Scrolls")
    patron_3.add_interest("Dead Sea Scrolls")
    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)

    expect(dmns.patrons).to eq([patron_1, patron_2, patron_3])
  end

  it "can find the lowest exhibit cost" do
    dmns.add_exhibit(dead_sea_scrolls)
    expect(dmns.lowest_cost).to eq 10
    dmns.add_exhibit(imax)
    expect(dmns.lowest_cost).to eq 10
    dmns.add_exhibit(gems_and_minerals)
    expect(dmns.lowest_cost).to eq 0
  end

  it "can group by intrests" do
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    patron_2.add_interest("Dead Sea Scrolls")
    patron_3.add_interest("Dead Sea Scrolls")
    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)

    expectation = {
      gems_and_minerals => [patron_1],
      dead_sea_scrolls => [patron_1, patron_2, patron_3],
      imax => []
    }

    expect(dmns.patrons_by_exhibit_interest).to eq(expectation)
  end

  it "can generate lotery contestants" do
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    patron_2.add_interest("Dead Sea Scrolls")
    patron_3.add_interest("Dead Sea Scrolls")
    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)
    expected = [patron_1, patron_3]

    expect(dmns.ticket_lottery_contestants(dead_sea_scrolls)).to eq(expected)
  end

  it "can pick a lotery winner" do
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    patron_2.add_interest("Dead Sea Scrolls")
    patron_3.add_interest("Dead Sea Scrolls")
    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)

    expect(dmns.draw_lottery_winner(dead_sea_scrolls)).to eq(patron_1 || patron_3)
    expect(dmns.draw_lottery_winner(gems_and_minerals)).to eq(nil)
  end
end
