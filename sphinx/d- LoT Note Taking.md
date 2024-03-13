# LoT Note Taking

Line of Thoughts (_LoT_) is a new note taking method. It avoids some common
misuse of our existing technology and tries to streamline the note taking
process.

## LoT Features
The main idea of LoT note taking is based on the following features.

- Continuous scroll of notes.
- Embedding of notes in more than one places.
- Custom ordering and reordering of notes.
- Ability to provide context before a note.
- Ability to provide summary or main ideas of a large note.

## LoT Cards
Line of thoughts notes are divided into cards. They are the atomic units of
notes. Linking between cards are not allowed because they lack context. A card
cannot embed another card. If the contents of a card is long, it can have two
major parts, (a) summary, and (b) details. If a card has details section, only
the summary should be embedded in decks. To be able to embed nicely, the
summary section should be under a H5 or H6 heading, with a suitable title for
the card.

## LoT Decks
LoT decks are collection of atomic notes known as cards. The cards
are embedded in a deck. The order of the cards are important to maintain a
proper flow and understanding of the line of thought in the deck.

A deck should have additional details, introductions to give context to the
embedded cards. For example, personal ideas and understanding can be added to a
deck before referencing a card which contains excerpts from external sources.

A deck can link to other related decks. But notes must be embedded. A
collection of decks create a group. One deck can be linked under multiple
groups.

## LoT Groups
Often it is necessary to collect a set of decks under a broader
topic. In the LoT method, we call these broader topics as groups. Unlike the
decks and the cards, groups do not have separate pages/notes. The HOME page
contains the list of currently active groups. Under each group, relevant decks
will be linked. The same deck can belong to multiple groups. The decks are only
linked, not embedded.

## The LoT Homepage
The initial page of the LoT notes. It organizes the active
decks in groups. The Homepage should not embed any note, only have links to
decks. Links to a deck can appear under multiple groups.

## LoT Note Taking Using Sphinx
SphinxNotes, built on top of Sphinx is useful to convert the notes into a
website or pdf file. It can also be used to run a personal static website,
for example, GitHub pages.

For all kinds of notes, use texts instead of lists, so writing and explaining
becomes easier. Even using small paragraphs containing a few sentences make
the text flow coherently.

## LoT Note Taking Using NeoVim
The Telescope plugin can be used to search for decks and cards easily. It is
not necessary to use the file navigator.

```{include} ./Using NeoVim with Sphinx Projects.md 
:end-before: ---
```


