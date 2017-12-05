require 'yaml'
require 'tk'
require 'tkextlib/tile'
require_relative 'client'
require_relative 'admin'
require_relative 'event'
require_relative 'field'
require_relative 'invoice'
require_relative 'reservation'

# Data
@clients = {}
@clientsdata = YAML::load_file(File.join(__dir__, "clients.yml"))
@clientsdata.each { |name| @clients[name[0]] = Client.new(name[1][:id],
   name[1][:username], name[1][:pass], name[1][:email])}

@fields = [Field.new('Anfield', 400), Field.new('Wembley', 200)]

# Windows
root = TkRoot.new { title "Home" }
root.bind("Destroy") { output = YAML.dump @clientsdata
                      File.write("clients.yml", output)}
log_win = TkToplevel.new { title "Welcome" }
log_win.bind("Destroy") { root.destroy() }

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
entInUsr.focus
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
    @current = @clients[ent1.get]
    curwin.withdraw
    nextwin.deiconify
  else
    lbl1.foreground = 'red'
    lbl2.foreground = 'red'
  end
end

def validate_signup(lbl1, ent1, ent2, ent3, curwin, nextwin)
  unless @clients.key?(ent1.get)
    @clientsdata[ent1.get] = {id:"c", username: ent1.get, pass: ent2.get, email: ent3.get}
    @clients[ent1.get] = Client.new("c", ent1.get, ent2.get, ent3.get)
    @current = @clients[ent1.get]
    lbl1.foreground = 'black'
    curwin.withdraw
    nextwin.deiconify
  else
    lbl1.foreground = 'red'
  end
end
# ==============================================================================
# HOME
# ==============================================================================
TkGrid.columnconfigure root, 0, :weight => 1
TkGrid.rowconfigure root, 0, :weight => 1
# Home Frames ------------------------------------------------------------------
fieldscont = Tk::Tile::Labelframe.new(root) {text "Fields";
          padding "30 20 30 20"; borderwidth "2"; relief "sunken"}
          .grid( :column => 1, :row => 1, :sticky => 'n')
@myrescont = Tk::Tile::Labelframe.new(root) {text "My Account";
          padding "30 20 30 20"; borderwidth "2"; relief "sunken"}
          .grid( :column => 2, :row => 1, :sticky => 'n')
# fieldscont widgets -----------------------------------------------------------
Tk::Tile::Label.new(fieldscont, :text=>'Available fields:').pack
cmbx = Tk::Tile::Combobox.new(fieldscont, :textvariable=>"Anfield",
          :values=>[@fields[0].name, @fields[1].name]).pack
radio_value = TkVariable.new ( 0 );
Tk::Tile::RadioButton.new(fieldscont, :text=>"Check availability",
          :variable=>radio_value, :value=>0).pack
Tk::Tile::RadioButton.new(fieldscont, :text=>"Reserve",
          :variable=>radio_value, :value=>1).pack
Tk::Tile::Label.new(fieldscont, :text=>'Enter day:').pack
entResDay = Tk::Tile::Entry.new(fieldscont).pack
Tk::Tile::Label.new(fieldscont, :text=>'Enter hour:').pack
entResHr = Tk::Tile::Entry.new(fieldscont).pack
Tk::Tile::Button.new(fieldscont, :text=>'Submit',
          :command=>proc{check_fields(cmbx.current, radio_value,
          entResDay.get.to_i , entResHr.get.to_i)}).pack
# myrescont widgets ------------------------------------------------------------
Tk::Tile::Label.new(@myrescont, :text=>'My reservations:').pack

# Home Functions ---------------------------------------------------------------
def check_fields(which, operation, day, hour)
  notif = TkToplevel.new { title "Alert" }
  TkGrid.columnconfigure notif, 0, :weight => 1
  TkGrid.rowconfigure notif, 0, :weight => 1
  notifcont = Tk::Tile::Labelframe.new(notif) {text "";
            padding "30 20 30 20"; borderwidth "2"; relief "sunken"}
            .grid( :column => 1, :row => 1, :sticky => 'n')

  if @fields[which].available?(day, hour)
    Tk::Tile::Label.new(notifcont, :text=>'Available.').pack
    Tk::Tile::Button.new(notifcont, :text=>'Reserve?',
              :command=>proc{answ = @fields[which].make_reservation(@current,
              day, hour);
              if answ.instance_of?(Reservation)
                 newres = answ.field.name + (', '+ day.to_s + 'd.') + (
                 ', ' + hour.to_s + 'hr.')
                 Tk::Tile::Label.new(@myrescont,
                 :text=>newres).pack
              end
              notif.destroy()}).pack
  else
    Tk::Tile::Label.new(notifcont, :text=>'Unavailable.').pack
  end
end
# ==============================================================================
Tk.mainloop
