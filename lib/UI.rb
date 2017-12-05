require 'tk'
require 'tkextlib/tile'
require_relative 'client'
require_relative 'admin'
require_relative 'event'
require_relative 'field'
require_relative 'invoice'
require_relative 'reservation'

# Data
@clients = { 'mrjslau'=>Client.new('c1510766', 'mrjslau', 'foot', 'mar@test.com') }

# Windows
root = TkRoot.new { title "Home" }
log_win = TkToplevel.new { title "Welcome" }

root.withdraw

# LOGIN
# ==============================================================================
TkGrid.columnconfigure log_win, 0, :weight => 1
TkGrid.rowconfigure log_win, 0, :weight => 1
# Log Frames -------------------------------------------------------------------
logincont = Tk::Tile::Labelframe.new(log_win) {text "Log in";
          padding "30 20 30 20"; borderwidth "2"; relief "sunken"}
          .grid( :column => 1, :row => 1, :sticky => 'n')
signupcont = Tk::Tile::Labelframe.new(log_win) {text "Sign Up";
          padding "30 20 30 20"; borderwidth "2"; relief "sunken"}
          .grid( :column => 2, :row => 1, :sticky => 'n')

# Logincont widgets ------------------------------------------------------------
lblInUsr = Tk::Tile::Label.new(logincont, :text=>'Enter your username').pack
entInUsr = Tk::Tile::Entry.new(logincont).pack
lblInPass = Tk::Tile::Label.new(logincont, :text=>'Enter your password').pack
entInPass = Tk::Tile::Entry.new(logincont).pack
Tk::Tile::Button.new(logincont, :text=>'Submit',
    :command=>proc{validate_login(lblInUsr, lblInPass,
    entInUsr, entInPass, log_win, root)}).pack
# Signupcont widgets -----------------------------------------------------------
lblUpUsr = Tk::Tile::Label.new(signupcont, :text=>'Enter username').pack
entUpUsr = Tk::Tile::Entry.new(signupcont).pack
Tk::Tile::Label.new(signupcont, :text=>'Enter password').pack
entUpPass = Tk::Tile::Entry.new(signupcont).pack
Tk::Tile::Label.new(signupcont, :text=>'Enter email').pack
entUpEml = Tk::Tile::Entry.new(signupcont).pack
Tk::Tile::Button.new(signupcont, :text=>'Submit',
  :command=>proc{validate_signup(lblUpUsr, entUpUsr,
  entUpPass, entUpEml, log_win, root)}).pack
# Log/Sign Functions
def validate_login(lbl1, lbl2, ent1, ent2, curwin, nextwin)
  if @clients.key?(ent1.get) && @clients[ent1.get].validate_pass(ent2.get)
    lbl1.foreground = 'black'
    lbl2.foreground = 'black'
    curwin.withdraw
    nextwin.deiconify
  else
    lbl1.foreground = 'red'
    lbl2.foreground = 'red'
  end
end

def validate_signup(lbl1, ent1, ent2, ent3, curwin, nextwin)
  unless @clients.key?(ent1.get)
    @clients[ent1.get] = Client.new("c", ent1.get, ent2.get, ent3.get)
    lbl1.foreground = 'black'
    curwin.withdraw
    nextwin.deiconify
  else
    lbl1.foreground = 'red'
  end
end
# ==============================================================================


Tk.mainloop
