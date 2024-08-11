for more info take a look this website:

1. https://firebase.flutter.dev/docs/database/overview

add this packages in your pubspec.yaml file:

    firebase_database: ^11.0.4

read more about firebase database that there is no tables or records
all data save in json tree

1. https://firebase.flutter.dev/docs/database/structure-data#how-data-is-structured-its-a-json-tree

for ex:

    {
        // This is a poorly nested data architecture, because iterating the children
        // of the "chats" node to get a list of conversation titles requires
        // potentially downloading hundreds of megabytes of messages
        "chats": {
            "one": {
                "title": "Historical Tech Pioneers",
                "messages": {
                "m1": { "sender": "ghopper", "message": "Relay malfunction found. Cause: moth." },
                "m2": { ... },
                // a very long list of messages
                }
            },
            "two": { ... }
        }
    }