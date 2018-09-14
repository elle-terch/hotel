require_relative 'spec_helper'
require 'pry'

describe "Reservation Hub class" do

  before do
    @reservation_hub = Hotel::ReservationHub.new
  end

  describe "Reservation Hub initialization" do

    it "is an instance of Reservation Hub" do

      expect(@reservation_hub).must_be_kind_of Hotel::ReservationHub

    end

    it "can access all rooms in the hotel" do

      expect(@reservation_hub.room_bookings.keys.length).must_equal 20

    end

    it "must initialize with an empty array of reservations" do

      expect(@reservation_hub.reservations).must_be_kind_of Array
      expect(@reservation_hub.reservations.length).must_equal 0

    end

    it "must initialize with a hash and corresponding empty arrays for each room" do

      expect(@reservation_hub.room_bookings).must_be_kind_of Hash
      expect(@reservation_hub.room_bookings.length).must_equal 20
      expect(@reservation_hub.room_bookings[1]).must_equal []

    end

    it "must be able to access all reservations and room bookings" do

      expect(@reservation_hub).must_respond_to :reservations
      expect(@reservation_hub).must_respond_to :room_bookings

    end

    it "raises an error if the start date is after the end date" do

      start_date = Date.new(2018,01,05)
      end_date = Date.new(2018,01,02)
      expect{@reservation_hub.add_reservation(start_date, end_date)}.must_raise ArgumentError

    end
  end


  describe "add reservation" do
    before do
      start_date1 = Date.new(2018,01,03)
      end_date1 = Date.new(2018,01,06)

      start_date2 = Date.new(2018,04,06)
      end_date2 = Date.new(2018,04,11)

      @reservation1 = @reservation_hub.add_reservation(start_date1, end_date1)

      @reservation2 = @reservation_hub.add_reservation(start_date2, end_date2)

    end

    it "returns a new reservation" do

      expect(@reservation1).must_be_kind_of Hotel::Reservation
      expect(@reservation2).must_be_kind_of Hotel::Reservation

    end

    it "adds a new reservation to array of all reservations" do

      expect(@reservation_hub.reservations.length).must_equal 2

    end
  end


  describe "create date array" do

    before do
      start_date = Date.new(2018,01,06)
      @end_date = Date.new(2018,01,10)

      @date_array = @reservation_hub.create_date_array(start_date, @end_date)

      @test_dates = []
      until start_date == @end_date
        @test_dates << start_date
        start_date +=1
      end

    end

    it "returns an array of all dates" do
      expect(@date_array).must_be_kind_of Array
      expect(@date_array.length).must_equal @test_dates.length
    end

    it "includes all dates in the reservation, not including the end date" do
      expect(@date_array).wont_include @end_date
      expect(@date_array).must_equal @test_dates

    end
  end


  describe "check available rooms method" do

    it "returns an array of 20 rooms upon initialization" do

      reservation_dates = [1,2]

      available_rooms = @reservation_hub.check_available_rooms(reservation_dates)

      expect(available_rooms.length).must_equal 20
      expect(available_rooms).must_be_kind_of Array
    end

    it "doesn't include rooms that have already been booked" do

      start_date = 1
      end_date = 3

      @reservation1 = @reservation_hub.add_reservation(start_date, end_date)

      @reservation2 = @reservation_hub.add_reservation(start_date, end_date)

      @reservation_dates = [1,2]


      available_rooms = @reservation_hub.check_available_rooms(@reservation_dates)

      expect(available_rooms.length).must_equal 18

    end
  end


  describe "assign room" do

    before do
      @reservation_dates = [1,2,3]
    end

    it "will assign the first value in the array to the reservation" do

      room_id = @reservation_hub.assign_room(@reservation_dates)
      expect(room_id).must_equal 1

    end

    it "won't duplicate room ids if two reservations share the same dates" do

      reservation_dates = [1,2,3]
      room_id = @reservation_hub.assign_room(reservation_dates)
      room_id2 = @reservation_hub.assign_room(reservation_dates)
      expect(room_id).must_equal 1
      expect(room_id2).must_equal 2

    end

    it "raises an error if the hotel is fully booked" do

      start_date = Date.new(2018,01,05)
      end_date = Date.new(2018,01,06)

      20.times do
        @reservation_hub.add_reservation(start_date, end_date)
      end

      expect{@reservation_hub.add_reservation(start_date, end_date)}.must_raise StandardError
    end
  end


  # describe "find reservation" do
  #
  #   before do
  #     start_date1 = Date.new(2018,01,03)
  #     end_date1 = Date.new(2018,01,06)
  #     start_date2 = Date.new(2018,02,05)
  #     end_date2 = Date.new(2018,02,15)
  #     start_date3 = Date.new(2018,01,11)
  #     end_date3 = Date.new(2018,01,21)
  #     start_date4 = Date.new(2018,01,03)
  #     end_date4 = Date.new(2018,01,05)
  #
  #     @reservation_hub = Hotel::ReservationHub.new
  #     @reservation_hub.add_reservation(start_date1, end_date1)
  #     @reservation_hub.add_reservation(start_date2, end_date2)
  #     @reservation_hub.add_reservation(start_date3, end_date3)
  #     @reservation_hub.add_reservation(start_date4, end_date4)
  #   end
  #
  #   it "returns a list of reservations based on a start date" do
  #
  #     start_date = Date.new(2018,01,03)
  #
  #     reservations = @reservation_hub.find_reservations(start_date)
  #
  #     expect(reservations).must_be_kind_of Array
  #
  #     expect(reservations.length).must_equal 2
  #   end
  # end


  # describe "all reservations" do
  #
  #   before do
  #     @reservation_hub = Hotel::ReservationHub.new
  #
  #     start_date1 = Date.new(2018,01,03)
  #     end_date1 = Date.new(2018,01,06)
  #     start_date2 = Date.new(2018,02,05)
  #     end_date2 = Date.new(2018,02,15)
  #     start_date3 = Date.new(2018,01,11)
  #     end_date3 = Date.new(2018,01,21)
  #
  #     @reservation_hub.add_reservation(start_date1, end_date1)
  #     @reservation_hub.add_reservation(start_date2, end_date2)
  #     @reservation_hub.add_reservation(start_date3, end_date3)
  #   end
  #
  #   it "returns an array of all reservations" do
  #     reservations = @reservation_hub.all_reservations
  #
  #     expect(reservations.length).must_equal 3
  #
  #     reservations.each do |res|
  #       expect(res).must_be_kind_of Hotel::Reservation
  #     end
  #   end
  # end

end
