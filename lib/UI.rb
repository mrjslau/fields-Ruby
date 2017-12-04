require 'tk'
require_relative 'client'
require_relative 'admin'
require_relative 'event'
require_relative 'field'
require_relative 'invoice'
require_relative 'reservation'

# Windows
root = TkRoot.new
signin_win = TkToplevel.new
signup_win = TkToplevel.new
main_win = TkToplevel.new

# Leave only root when starting
signin_win.withdraw
signup_win.withdraw
main_win.withdraw

# Data
fields = [Field.new('Anfield', 100), Field.new('Wembley', 200)]
clients = { 'mrjslau' => Client.new('c1510766', 'mrjslau', 'foot', 'mar@test.com') }

# root widgets
TkLabel.new(root, :text=>'Welcome to Fields reservations').pack
TkButton.new(root, :text=>'Sign In',
             :command=>proc{root.withdraw; signin_win.deiconify}).pack
TkButton.new(root, :text=>'Sign Up',
             :command=>proc{root.withdraw; signup_win.deiconify}).pack

# frames


# signin_win widgets
labelInUsr = TkLabel.new(signin_win, :text=>'Enter your username').pack
entryInUsr = TkEntry.new(signin_win).pack
labelInPass = TkLabel.new(signin_win, :text=>'Enter your password').pack
entryInPass = TkEntry.new(signin_win).pack
TkButton.new(signin_win, :text=>'Submit',
             :command=>proc{if clients.key?(entryInUsr.get) && clients[entryInUsr.get].validate_pass(entryInPass.get)
                              signin_win.withdraw
                              main_win.deiconify
                              labelInUsr.foreground = 'black'
                              labelInPass.foreground = 'black'
                            else
                              labelInUsr.foreground = 'red'
                              labelInPass.foreground = 'red'
                            end}).pack

# signup_win widgets
labelUpUsr = TkLabel.new(signup_win, :text=>'Enter username').pack
entryUpUsr = TkEntry.new(signup_win).pack
labelUpPass = TkLabel.new(signup_win, :text=>'Enter password').pack
entryUpPass = TkEntry.new(signup_win).pack
labelUpEml = TkLabel.new(signup_win, :text=>'Enter email').pack
entryUpEml = TkEntry.new(signup_win).pack
TkButton.new(signup_win, :text=>'Submit',
             :command=>proc{if !clients.key?(entryUpUsr.get)
                              clients[entryUpUsr.get] = Client.new('c2', entryUpUsr.get, entryUpPass.get, entryUpEml.get)
                              signup_win.withdraw
                              main_win.deiconify
                              labelUpUsr.foreground = 'black'
                              labelUpPass.foreground = 'black'
                              labelUpEml.foreground = 'black'
                            else
                              labelUpUsr.foreground = 'red'
                            end}).pack

# main_win widgets
labelWelcome = TkLabel.new(main_win, :text=>'You are signed in').pack

Tk.mainloop

=begin
root = TkRoot.new
root.title = "Window"

f1 = TkFrame.new {
   borderwidth 3
   background "white"
   padx 250
   pady 150
   pack('side' => 'left')
}

$resultsVar = TkVariable.new
StartLbl = TkLabel.new(f1) do
   textvariable
   borderwidth 5
   font TkFont.new('times 20 bold')
   foreground  "black"
   pack("side" => "top")
end

StartLbl['textvariable'] = $resultsVar
$resultsVar.value = 'Welcome to Fields reservations'

BtnIn = TkButton.new(f1) {
   text 'Sign In'
   command {root = TkRoot.new}
   pack('fill' => 'x')
}
BtnUp = TkButton.new(f1) {
   text 'Sign Up'
   command {print "pushed sign-up!!\n"}
   pack('fill' => 'x')
}

Tk.mainloop
=end
