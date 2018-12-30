### Weather Report Using wttr.in api


For the wttr.in api info and use, visit the [wttr.in](http://wttr.in/) web site and [github repo](http://github.com/chubin/wttr.in).


#### calling the api with wttr_loop for multiple locations

__Synopsis__
The script will loop over a number of provided locations with a delay
between each call to the wttr api, and direct each returned response to a text file.


__using files:__
wttr_loop $(cat location{1,2}.txt)
- this method of running the script will expand the contents of any
  number of location files provided, as positional arguments to the script.

__command-line positional arguments:__
wttr_loop highgate+london boston+usa


#### Acquiring the weather reports

- a delay interval occures after each GET request (except the last).
  By default, the delay is set to 60 seconds.
  This is implemented to avoid 'spamming' the api.

- the script will merge the <location> with the necessary flags to
  generate a single current weather report,
  the api flags, ~<location>?QM0 are used
  the '~' generates location infomation including coordinates

- the response to each request is redirected into its individual
  text file, following a naming convention using the first name in
  the location argument,
  e.g. from 'boston+usa' > boston.txt
  and saved in the a cache directory (to be configured)


#### the arguments format as files

e.g. highgate+london
     boston+usa

     each location on a separate line, a place and city or city and country
     separated by a '+' no spaces.


#### the date option format <NOT YET IMPLEMENTED>

If the cli option -d is selected, `date -R' is used to generate basic time and
date information.

- TZ can also be set as part of the argument. this uses the 'tzselect(1)' cmd
  method of configuring the tz data
  (coordinates conforming to ISO 6709 can also be used to find the TZ code via
  tzselect).

e.g. boston+usa-America/New_York

  from tzselect for Boston USA (east coast), TZ='America/New_York'

- If no TZ info is provided, but -d is selected, the time/date of the user
  'system locale' will be given.


