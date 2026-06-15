# Finview_lite

## 1. Flutter & Dart Version
    -- Flutter SDK [3.44.1]
    -- Dart SDK [3.12.1] 

## 2. Dependencies
    -- equatable
    -- fl_chart
    -- shared_preferences

## 3. How to run
    -- [Step 1] : flutter clean
    -- [Step 2] : flutter pub get
    -- [Step 3] : flutter run

## Description of UI
    -- The UI consists of a Dashboard Screen designed for portfolio management and financial data visualization.

    -- The Dashboard screen has a header with User Greetings, the User's Name, a Manual Refresh button, and a Theme Toggle Button.

    -- It features local State Persistence using shared preferences to remember the user's chosen app theme across restarts.

    -- The screen displays a User Portfolio Summary showing both the Total Portfolio Value and Total Gain.

    -- Users can interactively toggle to view all investment amounts in either Raw Currency Value or Percentage Yield.

    -- It includes an interactive Pie Chart for visual asset allocation across the portfolio.

    -- It features a dedicated sorting mechanism to organize your holdings instantly by Value, Gain, or Alphabetical Name.
    
    -- It includes a scrollable Holdings List View displaying individual assets with their specific total value and dynamic gain/loss 
       status  in amount or percentage.