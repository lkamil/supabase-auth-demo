
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

### Info

#### Resource Embedding
Allows to retrieve data from two (linked) tables using only one API call.

For example, instead of querying notes and images seperately:
```
func fetchNotes() async throws -> [APINoteModel] {
    try await client
        .from("notes")
        .select()
        .order("created_at", ascending: false)
        .execute()
        .value
}

func fetchImages(noteId: UUID) async throws -> [APINoteImageModel] {
    try await client
        .from("note_images")
        .select()
        .eq("note_id", value: noteId)
        .order("created_at", ascending: true)
        .execute()
        .value
}
```

I can also query the images directly with the notes (making a seperate fetchImages() method obsolete):

```
func fetchNotes() async throws -> [APINoteModel] {
    try await client
        .from("notes")
        .select("*, note_images(*)")
        .order("created_at", ascending: false)
        .execute()
        .value
}
```
