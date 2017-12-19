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
@fields = [Field.new('Anfield', 400), Field.new('Wembley', 200)]

# Windows
@root = TkRoot.new { title 'Home' }
@root.bind('Destroy') do
  Client.save_clients('../yaml/clients.yml')
end
@log_win = TkToplevel.new { title 'Welcome' }
@log_win.bind('Destroy') { @root.destroy }

@root.withdraw
# LOGIN
# ==============================================================================
TkGrid.columnconfigure @log_win, 0, weight: 1
TkGrid.rowconfigure @log_win, 0, weight: 1
# Log Frames -------------------------------------------------------------------
logincont = Tk::Tile::Labelframe.new(@log_win) do
  text 'Log in'
  padding '30 20 30 20'
  borderwidth '2'
  relief 'sunken'
end
                                .grid(column: 1, row: 1, sticky: 'n')
signupcont = Tk::Tile::Labelframe.new(@log_win) do
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
Tk::Tile::Button.new(logincont, text: 'Submit', command: proc {
  validate_login(lbl_in_usr, lbl_in_pass, ent_in_usr.get, ent_in_pass.get)
}).pack
# Signupcont widgets -----------------------------------------------------------
lbl_up_usr = Tk::Tile::Label.new(signupcont, text: 'Enter username').pack
ent_up_usr = Tk::Tile::Entry.new(signupcont).pack
Tk::Tile::Label.new(signupcont, text: 'Enter password').pack
ent_up_pass = Tk::Tile::Entry.new(signupcont).pack
Tk::Tile::Label.new(signupcont, text: 'Enter email').pack
ent_up_eml = Tk::Tile::Entry.new(signupcont).pack
Tk::Tile::Button.new(signupcont, text: 'Submit', command: proc {
  validate_signup(lbl_up_usr, ent_up_usr.get, ent_up_pass.get, ent_up_eml.get)
}).pack
# Log/Sign Functions
def validate_login(lbl_in_usr, lbl_in_pass, value_usr, value_pass)
  if Client.validate_login(value_usr, value_pass)
    @user = Client.get_client(value_usr)
    @log_win.withdraw
    @root.deiconify
  else
    lbl_in_usr.foreground = lbl_in_pass.foreground = 'red'
  end
end

def validate_signup(lbl_up_usr, value_usr, value_pass, value_eml)
  if !Client.look_for_client(value_usr)
    credentials = {
      id: 20, username: value_usr, password: value_pass, email: value_eml
    }
    @user = Client.add_new_client(credentials[:username], credentials)
    @log_win.withdraw
    @root.deiconify
  else
    lbl_up_usr.foreground = 'red'
  end
end
# ==============================================================================
# HOME
# ==============================================================================
TkGrid.columnconfigure @root, 0, weight: 1
TkGrid.rowconfigure @root, 0, weight: 1
# Home Frames ------------------------------------------------------------------
fieldscont = Tk::Tile::Labelframe.new(@root) do
  text 'Fields'
  padding '30 20 30 20'
  borderwidth '2'
  relief 'sunken'
end
                                 .grid(column: 1, row: 1, sticky: 'n')
@myrescont = Tk::Tile::Labelframe.new(@root) do
  text 'My Account'
  padding '30 20 30 20'
  borderwidth '2'
  relief 'sunken'
end
                                 .grid(column: 2, row: 1, sticky: 'n')
# fieldscont widgets -----------------------------------------------------------
Tk::Tile::Label.new(fieldscont, text: 'Available fields:').pack
cmbx = Tk::Tile::Combobox.new(
  fieldscont,
  textvariable: 'Anfield',
  values: [@fields[0].name, @fields[1].name]
).pack
Tk::Tile::Label.new(fieldscont, text: 'Enter day:').pack
ent_res_day = Tk::Tile::Entry.new(fieldscont).pack
Tk::Tile::Label.new(fieldscont, text: 'Enter hour:').pack
ent_res_hr = Tk::Tile::Entry.new(fieldscont).pack
Tk::Tile::Button.new(fieldscont, text: 'Submit', command: proc {
  check_fields(cmbx.current, ent_res_day.get.to_i, ent_res_hr.get.to_i)
}).pack
# myrescont widgets ------------------------------------------------------------
Tk::Tile::Label.new(@myrescont, text: 'My reservations:').pack
# Notification window ----------------------------------------------------------
@notif = TkToplevel.new { title 'Alert' }
TkGrid.columnconfigure @notif, 0, weight: 1
TkGrid.rowconfigure @notif, 0, weight: 1
@notifcont = Tk::Tile::Frame.new(@notif) do
  padding '30 20 30 20'
  borderwidth '2'
  relief 'sunken'
end
                            .grid(column: 1, row: 1, sticky: 'n')

@notif.withdraw
# Home Functions ---------------------------------------------------------------
def check_fields(which, day, hour)
  @notif.deiconify
  if @fields[which].available?(day, hour)
    av_lbl = Tk::Tile::Label.new(@notifcont, text: 'Available.').pack
    res_qst = Tk::Tile::Button.new(@notifcont, text: 'Reserve?', command: proc {
      answ = @fields[which].make_reservation(@user, day, hour)
      if answ.instance_of?(Reservation)
        newres = answ.field.name + (', ' + day.to_s + 'd.') +
        (', ' + hour.to_s + 'hr.')
        Tk::Tile::Label.new(@myrescont, text: newres).pack
      end
      av_lbl.destroy
      res_qst.destroy
      @notif.withdraw
    }).pack
  else
    unv_lbl = Tk::Tile::Label.new(@notifcont, text: 'Unavailable.').pack
    qt_qst = Tk::Tile::Button.new(@notifcont, text: 'Go Back', command: proc {
      unv_lbl.destroy
      qt_qst.destroy
      @notif.withdraw
    }).pack
  end
end
# ==============================================================================
Tk.mainloop
# End
