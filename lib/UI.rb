require 'yaml'
require 'tk'
require 'tkextlib/tile'
require_relative 'loader'
require_relative 'client'
require_relative 'admin'
require_relative 'event'
require_relative 'field'
require_relative 'invoice'
require_relative 'reservation'

# Data
@clients = {}
@clientsdata = YAML.load_file(File.join(__dir__, 'clients.yml'))
@clientsdata.each do |name|
  @clients[name[0]] = Client.new(
    name[1][:id], name[1][:username], name[1][:pass], name[1][:email]
  )
end

@fields = [Field.new('Anfield', 400), Field.new('Wembley', 200)]

# Windows
root = TkRoot.new { title 'Home' }
root.bind('Destroy') do
  output = YAML.dump @clientsdata
  File.write('clients.yml', output)
end
log_win = TkToplevel.new { title 'Welcome' }
log_win.bind('Destroy') { root.destroy }

root.withdraw

# LOGIN
# ==============================================================================
TkGrid.columnconfigure log_win, 0, weight: 1
TkGrid.rowconfigure log_win, 0, weight: 1
# Log Frames -------------------------------------------------------------------
logincont = Tk::Tile::Labelframe.new(log_win) do
  text 'Log in'
  padding '30 20 30 20'
  borderwidth '2'
  relief 'sunken'
end
                                .grid(column: 1, row: 1, sticky: 'n')
signupcont = Tk::Tile::Labelframe.new(log_win) do
  text 'Sign Up'
  padding '30 20 30 20'
  borderwidth '2'
  relief 'sunken'
end
                                 .grid(column: 2, row: 1, sticky: 'n')

# Logincont widgets ------------------------------------------------------------
lbl_in_usr = Tk::Tile::Label.new(logincont, text: 'Enter your username').pack
ent_in_usr = Tk::Tile::Entry.new(logincont).pack
ent_in_usr.focus
lbl_in_pass = Tk::Tile::Label.new(logincont, text: 'Enter your password').pack
ent_in_pass = Tk::Tile::Entry.new(logincont).pack
Tk::Tile::Button.new(logincont, text: 'Submit', command: proc { validate_login(lbl_in_usr, lbl_in_pass, ent_in_usr, ent_in_pass, log_win, root) }).pack
# Signupcont widgets -----------------------------------------------------------
lbl_up_usr = Tk::Tile::Label.new(signupcont, text: 'Enter username').pack
ent_up_usr = Tk::Tile::Entry.new(signupcont).pack
Tk::Tile::Label.new(signupcont, text: 'Enter password').pack
ent_up_pass = Tk::Tile::Entry.new(signupcont).pack
Tk::Tile::Label.new(signupcont, text: 'Enter email').pack
ent_up_eml = Tk::Tile::Entry.new(signupcont).pack
Tk::Tile::Button.new(signupcont, text: 'Submit',
  command: proc { validate_signup(lbl_up_usr, ent_up_usr,
  ent_up_pass, ent_up_eml, log_win, root) }).pack
# Log/Sign Functions
def validate_login(lbl_in_usr, lbl_in_pass, ent_in_usr, ent_in_pass, curwin, nextwin)
  if Client.look_for_client(ent_in_usr.get) && @clients[ent_in_usr.get].validate_pass(ent_in_pass.get)
    lbl_in_usr.foreground = lbl_in_pass.foreground = 'black'
    @current = @clients[ent_in_usr.get]
    curwin.withdraw
    nextwin.deiconify
  else
    lbl_in_usr.foreground = 'red'
    lbl_in_pass.foreground = 'red'
  end
end

def validate_signup(lbl_up_usr, ent_up_usr, ent_up_pass, ent_up_eml, curwin, nextwin)
  if !@clients.key?(ent_up_usr.get)
    @clientsdata[ent_up_usr.get] = { id: 'c', username: ent_up_usr.get, pass:  ent_up_pass.get, email: ent_up_eml.get }
    @clients[ent_up_usr.get] = Client.new('c', ent_up_usr.get, ent_up_pass.get, ent_up_eml.get)
    @current = @clients[ent_up_usr.get]
    lbl_up_usr.foreground = 'black'
    curwin.withdraw
    nextwin.deiconify
  else
    lbl_up_usr.foreground = 'red'
  end
end
# ==============================================================================
# HOME
# ==============================================================================
TkGrid.columnconfigure root, 0, weight: 1
TkGrid.rowconfigure root, 0, weight: 1
# Home Frames ------------------------------------------------------------------
fieldscont = Tk::Tile::Labelframe.new(root) do
  text 'Fields'
  padding '30 20 30 20'
  borderwidth "2"
  relief 'sunken'
end
                                 .grid( column: 1, row: 1, sticky: 'n')
@myrescont = Tk::Tile::Labelframe.new(root) do
  text 'My Account'
  padding '30 20 30 20'
  borderwidth '2'
  relief 'sunken'
end
                                 .grid( column: 2, row: 1, sticky: 'n')
# fieldscont widgets -----------------------------------------------------------
Tk::Tile::Label.new(fieldscont, text: 'Available fields:').pack
cmbx = Tk::Tile::Combobox.new(fieldscont, textvariable: 'Anfield',
          values: [@fields[0].name, @fields[1].name]).pack
radio_value = TkVariable.new ( 0 );
Tk::Tile::RadioButton.new(fieldscont, text: 'Check availability',
          variable: radio_value, value: 0).pack
Tk::Tile::RadioButton.new(fieldscont, text: 'Reserve',
          variable: radio_value, value: 1).pack
Tk::Tile::Label.new(fieldscont, text: 'Enter day:').pack
entResDay = Tk::Tile::Entry.new(fieldscont).pack
Tk::Tile::Label.new(fieldscont, text: 'Enter hour:').pack
entResHr = Tk::Tile::Entry.new(fieldscont).pack
Tk::Tile::Button.new(fieldscont, text: 'Submit',
          command: proc {check_fields(cmbx.current, radio_value,
          entResDay.get.to_i , entResHr.get.to_i)}).pack
# myrescont widgets ------------------------------------------------------------
Tk::Tile::Label.new(@myrescont, text: 'My reservations:').pack

# Home Functions ---------------------------------------------------------------
def check_fields(which, operation, day, hour)
  notif = TkToplevel.new { title 'Alert' }
  TkGrid.columnconfigure notif, 0, weight: 1
  TkGrid.rowconfigure notif, 0, weight: 1
  notifcont = Tk::Tile::Labelframe.new(notif) do
    text ''
    padding '30 20 30 20'
    borderwidth '2'
    relief 'sunken'
  end
                                  .grid( column: 1, row: 1, sticky: 'n')

  if @fields[which].available?(day, hour)
    Tk::Tile::Label.new(notifcont, text: 'Available.').pack
    Tk::Tile::Button.new(notifcont, text: 'Reserve?',
              command: proc { answ = @fields[which].make_reservation(@current,
              day, hour);
              if answ.instance_of?(Reservation)
                newres = answ.field.name + (', ' + day.to_s + 'd.') + (', ' + hour.to_s + 'hr.')
                Tk::Tile::Label.new(@myrescont, text: newres).pack
              end
              notif.destroy }).pack
  else
    Tk::Tile::Label.new(notifcont, text: 'Unavailable.').pack
  end
end
# ==============================================================================
Tk.mainloop
