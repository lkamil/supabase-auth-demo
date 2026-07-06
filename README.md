
## Supabase Auth Demo Project

### Build / Run

Add a `Secrets.xcconfig` file to the root folder. Add the project url and key.<br>
The url needs to be formated with a placeholder (`$()`), otherwise `//` would be interpreted as a comment.

````
SUPABASE_URL = https:/$()/your-project.supabase.co
SUPABASE_PUBLISHABLE_KEY = sb_publishable_<your-publishable-key-here>
````

### Set Up

- create a supabase account and project
- add the api keys to a Secrets.xcconfig file
- add `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY` as keys to the plist
- add `$(SUPABASE_URL)` and `$(SUPABASE_PUBLISHABLE_KEY)` as respective values to the keys
- add a observable AuthManager that can be accessed as an Environment from the views