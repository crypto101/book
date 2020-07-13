Hash functions
--------------

.. _description-5:

Description
~~~~~~~~~~~

Hash functions are functions that take an input of indeterminate length
and produce a fixed-length value, also known as a “digest”.

Simple hash functions have many applications. Hash tables, a common data
structure, rely on them. These simple hash functions really only
guarantee one thing: for two identical inputs, they'll produce an
identical output. Importantly, there's no guarantee that two identical
outputs imply that the inputs were the same. That would be impossible:
there's only a finite amount of digests, since they're fixed size, but
there's an infinite amount of inputs. A good hash function is also quick
to compute.

Since this is a book on cryptography, we're particularly interested in
*cryptographic* hash functions. Cryptographic hash functions can be used
to build secure (symmetric) message authentication algorithms,
(asymmetric) signature algorithms, and various other tools such as
random number generators. We'll see some of these systems in detail in
future chapters.

Cryptographic hash functions have much stronger properties than regular
hash functions, such as one that you might find in a hash table. For a
cryptographic hash function, we want it to be impossibly hard to:

#. modify a message without changing the hash.
#. generate a message that has a given hash.
#. find two different messages with the same hash.

The first property implies that cryptographic hash functions will
exhibit something known as the “avalanche effect”. Changing even a
single bit in the input will produce an avalanche of changes through the
entire digest: each bit of the digest will have approximately 50% chance
of flipping. That doesn't mean that every change *will* cause
approximately half of the bits to flip, but the cryptographic hash
function does guarantee that the odds of that happening are extremely
large. More importantly it is impossibly hard to find such collisions or
near-collisions.

The second property, which states that it should be difficult to find a
message :math:`m` that has a given hash value :math:`h`, is called
*pre-image resistance*. This makes a hash function a one-way function:
it's very easy to compute a hash for a given message, but it's very hard
to compute a message for a given hash.

The third property talks about finding messages with the same hash
value, comes in two flavors. In the first one, there's a given message
:math:`m`, and it should be difficult to find another message
:math:`m^{\prime}` with the same hash value: that's called *second
pre-image resistance*. The second one is stronger, stating that it
should be hard to find any two messages :math:`m, m^{\prime}` that have
the same hash value. This is called *collision resistance*. Because
collision resistance is a stronger form of second pre-image resistance,
they're sometimes also called weak and strong collision resistance.

These concepts are often named from the point of view of an attack,
rather than the resistance to an attack. For example, you'll often hear
about a collision attack, which is an attack that attempts to generate a
hash collision, or a second pre-image attack, which attempts to find a
second pre-image that hashes to the same value as a given pre-image, et
cetera.

TODO: Maybe link to
http://www.cs.ucdavis.edu/~rogaway/papers/relates.pdf for further
reading

MD5
~~~

MD5 is a hash function designed by Ronald Rivest in 1991 as an extension
of MD4. This hash function outputs 128-bit digests. Over the course of
the years, the cryptographic community has repeatedly uncovered MD5's
weaknesses. In 1993, Bert den Boer and Antoon Bosselaers published a
paper demonstrating “pseudo-collisions” for the compression function of
MD5. :cite:`denboer:md5` Dobbertin expanded upon this
research and was able to produce collisions for the compression
function. In 2004, based on Dobbertin's work, Xiaoyun Wang, Dengguo
Feng, Xuejia Lai and Hongbo Yu showed that MD5 is vulnerable to real
collision attacks. :cite:`cryptoeprint:2005:067` The last
straw came when Xiaoyun Wang et al. managed to generate colliding X.509
certificates and then presented a distinguishing attack on HMAC-MD5.
:cite:`cryptoeprint:2005:067`
:cite:`eurocrypt-2009-23793`

Nowadays, it is not recommended to use MD5 for generating digital
signatures, but it is important to note that HMAC-MD5 is still a secure
form of message authentication; however, it probably shouldn't be
implemented in new cryptosystems.

Five steps are required to compute an MD5 message digest:

#. Add padding. First, 1 bit is appended to the message and then 0 bits
   are added to the end until the length is :math:`448 \pmod {512}`.
#. Fill up the remaining 64 bits with the the length of the original
   message modulo :math:`2^{64}`, so that the entire message is a
   multiple of 512 bits.
#. Initialize the state as four 32-bit words, A, B, C and D. These are
   initialized with constants defined in the spec.
#. Process the input in 512 bit blocks; for each block, run four
   “rounds” consisting of 16 similar operations each. The operations all
   consist of shifts, modular addition, and a specific nonlinear
   function, different for each round.

Once done, :math:`A \| B \| C \| D` is the output of the hash. This
padding style combined with the concatenation at the end is what makes
MD5 vulnerable to length extension attacks; more on that later.

In Python one can use the hashlib module to create an MD5 digest as
follows:

.. code:: python

   import hashlib
   hashlib.md5(b"crypto101").hexdigest()

SHA-1
~~~~~

SHA-1 is another hash function from the MD4 family designed by the NSA,
which produces a 160-bit digest. Just like MD5, SHA-1 is no longer
considered secure for digital signatures. Many software companies and
browsers, including Google Chrome, have started to retire support of the
signature algorithm of SHA-1. On February 23, 2017 researchers from CWI
Amsterdam and Google managed to produce a collision on the full SHA-1
function. :cite:`Shattered` In the past methods to cause
collisions on reduced versions of SHA-1 have been published, including
one by Xiaoyun Wang. “The SHAppening” demonstrated freestart collisions
for SHA-1. A freestart collision allows one to pick the initial value
known as the :term:`initialization vector` at the start of the compression
function. :cite:`cryptoeprint:2015:967`

Once again the hashlib Python module can be used to generate a SHA-1
hash:

.. code:: python

   import hashlib
   hashlib.sha1(b"crypto101").hexdigest()

SHA-2
~~~~~

SHA-2 is a family of hash functions including SHA-224, SHA-256, SHA-384,
SHA-512, SHA-512/224 and SHA-512/256 and their digest sizes 224, 256,
384, 512, 224 and 256 respectively. These hash functions are based on
the Merkle–Damgård construction and can be used for digital signatures,
message authentication and random number generators. SHA-2 not only
performs better than SHA-1, it also provides better security, because of
its increase in collision resistance.

SHA-224 and SHA-256 were designed for 32-bit processor registers, while
SHA-384 and SHA-512 for 64-bit registers. The 32-bit register variants
will therefore run faster on a 32-bit CPU and the 64-bit variants will
perform better on a 64-bit CPU. SHA-512/224 and SHA-512/256 are
truncated versions of SHA-512 allowing use of 64-bit words with an
output size equivalent to the 32-bit register variants (i.e., 224 and
256 digest sizes and better performance on a 64-bit CPU).

The following is a table that gives a good overview of the SHA-2 family:

============= =============== ========== ========= ===========
Hash function Message size    Block size Word size Digest size
============= =============== ========== ========= ===========
SHA-224       < 2\ :sup:`64`  512        32        224
SHA-256       < 2\ :sup:`64`  512        32        256
SHA-384       < 2\ :sup:`128` 1024       64        384
SHA-512       < 2\ :sup:`128` 1024       64        512
SHA-512/224   < 2\ :sup:`128` 1024       64        224
SHA-512/256   < 2\ :sup:`128` 1024       64        256
============= =============== ========== ========= ===========

You can hash an empty string with the hashlib module and compare digest
sizes as follows:

.. code:: python

   >>> import hashlib
   >>> len(hashlib.sha224(b"").hexdigest())
   56
   >>> len(hashlib.sha256(b"").hexdigest())
   64
   >>> len(hashlib.sha384(b"").hexdigest())
   96
   >>> len(hashlib.sha512(b"").hexdigest())
   128

Attacks on SHA-2
^^^^^^^^^^^^^^^^

Several (pseudo-)collision and preimage attacks have been demonstrated
using SHA-256 and SHA-512 with less rounds. It is important to note that
by removing a certain amount of rounds one can't attack the entire
algorithm. For instance, Somitra Kumar Sanadhya and Palash Sarkar were
able to cause collisions with SHA-256 using 24 of 64 rounds (removing
the last 40 rounds). :cite:`eprint-2008-18172`

Keccak and SHA-3
~~~~~~~~~~~~~~~~

Keccak is a family of sponge functions designed by Guido Bertoni, Joan
Daemen, Gilles Van Assche and Michaël Peeters, which won NIST's Secure
Hash Algorithm Competition in 2012. Keccak has since been standardized
in form of the SHA3-224, SHA3-256, SHA3-384 and SHA3-512 hash functions.

Although SHA-3 sounds like it might come from the same family as SHA-2,
the two are designed very differently. SHA-3 is very efficient in
hardware :cite:`SHA-3-hardware`, but is relatively slow in
software in comparison to SHA-2. :cite:`SHA-3-finalists`
Later in the book, you will find the security aspects of SHA-3, such as
preventing length extension attacks.

The SHA-3 hash functions were introduced in Python version 3.6 and can
be used as follows:

.. code:: python

   import hashlib
   hashlib.sha3_224(b"crypto101").hexdigest()
   hashlib.sha3_256(b"crypto101").hexdigest()
   hashlib.sha3_384(b"crypto101").hexdigest()
   hashlib.sha3_512(b"crypto101").hexdigest()

.. _password storage:

Password storage
~~~~~~~~~~~~~~~~

One of the most common use cases for cryptographic hash functions, and
unfortunately one which is also completely and utterly broken, is
password storage.

Suppose you have a service where people log in using a username and a
password. You'd have to store the password somewhere, so that next time
the user logs in, you can verify the password they supplied.

Storing the password directly has several issues. Besides an obvious
timing attack in the string comparison, if the password database were to
be compromised, an attacker would be able to just go ahead and read all
of the passwords. Since many users re-use passwords, that's a
catastrophic failure. Most user databases also contain their e-mail
addresses, so it would be very easy to hi-jack a bunch of your user's
accounts that are unrelated to this service.

Hash functions to the rescue
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

An obvious approach would be to hash the password using a
cryptographically secure hash function. Since the hash function is easy
to compute, whenever the user provides their password, you can just
compute the hash value of that, and compare that to what you stored in
the database.

If an attacker were to steal the user database, they could only see the
hash values, and not the actual passwords. Since the hash function is
impossible for an attacker to inverse, they wouldn't be able to turn
those back into the original passwords. Or so people thought.

Rainbow tables
^^^^^^^^^^^^^^

It turns out that this reasoning is flawed. The amount of passwords that
people actually use is very limited. Even with very good password
practices, they're strings somewhere between 10 and 20 characters,
consisting mostly of things that you can type on common keyboards. In
practice though, people use even worse passwords: things based on real
words (``password``, ``swordfish``), consisting of few symbols and few
symbol types (``1234``), or with predictable modifications of the above
(``passw0rd``).

To make matters worse, hash functions are the same everywhere. If a user
re-uses the same password on two sites, and both of them hash the
password using MD5, the values in the password database will be the
same. It doesn't even have to be per-user: many passwords are extremely
common (``password``), so many users will use the same one.

Keep in mind that a hash function is easy to evaluate. What if we simply
try many of those passwords, creating huge tables mapping passwords to
their hash values?

That's exactly what some people did, and the tables were just as
effective as you'd expect them to be, completely breaking any vulnerable
password store. Such tables are called *rainbow tables*. This is because
they're essentially sorted lists of hash function outputs. Those outputs
will be more or less randomly distributed. When written down in
hexadecimal formats, this reminded some people of color specifications
like the ones used in HTML, e.g. ``#52f211``, which is lime green.

Salts
^^^^^

The reason rainbow tables were so incredibly effective was because
everyone was using one of a handful of hash functions. The same password
would result in the same hash everywhere.

This problem was generally solved by using :term:`salt`\s. By mixing (appending
or prepending [#]_) the password with some random value before hashing
it, you could produce completely different hash values out of the same
hash function. It effectively turns a hash function into a whole family
of related hash functions, with virtually identical security and
performance properties, except with completely different output values.

.. [#]
   While you could also do this with XOR, it's needlessly more
   error-prone, and doesn't provide better results. Unless you zero-pad
   both the password and the :term:`salt`, you might be truncating either one.

The :term:`salt` value is stored next to the password hash in the database. When
the user authenticates using the password, you just combine the :term:`salt`
with the password, hash it, and compare it against the stored hash.

If you pick a sufficiently large (say, 160 bits/32 bytes),
cryptographically random :term:`salt`, you've completely defeated ahead-of-time
attacks like rainbow tables. In order to successfully mount a rainbow
table attack, an attacker would have to have a separate table for each
of those :term:`salt` values. Since even a single table was usually quite large,
storing a large amount of them would be impossible. Even if an attacker
would be able to store all that data, they'd still have to compute it
first. Computing a single table takes a decent amount of time; computing
:math:`2^{160}` different tables is impossible.

Many systems used a single :term:`salt` for all users. While that prevented an
ahead-of-time rainbow table attack, it still allowed attackers to attack
all passwords simultaneously, once they knew the value of the :term:`salt`. An
attacker would simply compute a single rainbow table for that :term:`salt`, and
compare the results with the hashed passwords from the database. While
this would have been prevented by using a different :term:`salt` for each user,
systems that use a cryptographic hash with a per-user :term:`salt` are still
considered fundamentally broken today; they are just *harder* to crack,
but not at all secure.

Perhaps the biggest problem with :term:`salt`\s is that many programmers were
suddenly convinced they were doing the right thing. They'd heard of
broken password storage schemes, and they knew what to do instead, so
they ignored all talk about how a password database could be
compromised. They weren't the ones storing passwords in plaintext, or
forgetting to :term:`salt` their hashes, or re-using :term:`salt`\s for different users.
It was all of those other people that didn't know what they were doing
that had those problems. Unfortunately, that's not true. Perhaps that's
why broken password storage schemes are still the norm.

Modern attacks on weak password systems
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To a modern attack, :term:`salt`\s quite simply don't help. Modern attacks take
advantage of the fact that the hash function being used is easy to
compute. Using faster hardware, in particular video cards, we can simply
enumerate all of the passwords, regardless of :term:`salt`.

TODO: more concrete performance numbers about GPUs

:term:`Salt <salt>`\s may make precomputed attacks impossible, but they do very little
against an attacker that actually knows the :term:`salt`. One approach you might
be inclined to take is to attempt to hide the :term:`salt` from the attacker.
This typically isn't very useful: if an attacker can manage to access
the database, attempts to hide the :term:`salt` are unlikely to be successful.
Like many ineffective home-grown crypto schemes, this only protects
against an incredibly improbable event. It would be much more useful to
just use a good password store to begin with, than trying to fix a
broken one.

So where do we go from here?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In order to protect passwords, you need a (low-entropy) :ref:`key
derivation function <key derivation function>`. We'll discuss them in
more detail in a future chapter.

While key derivation functions can be built using cryptographic hash
functions, they have very different performance properties. This is a
common pattern: while cryptographic hash functions are incredibly
important primitives for building secure tools (such as key derivation
functions or message authentication algorithms), they are routinely
abused *as* those tools themselves. In the rest of this chapter, we will
see other examples of how cryptographic hash functions can be used and
abused.

Length extension attacks
~~~~~~~~~~~~~~~~~~~~~~~~

In many hash functions, particularly the previous generations, the
internal state kept by the hash function is used as the digest value. In
some poorly engineered systems, that causes a critical flaw: if an
attacker knows :math:`H(M_1)`, it's very simple to compute
:math:`H(M_1 \| M_2)`, without actually knowing the value of
:math:`M_1`. Since you know :math:`H(M_1)`, you know the state of the
hash function after it's hashed :math:`M_1`. You can use that to
reconstruct the hash function, and ask it to hash more bytes. Setting
the hash function's internal state to a known state you got from
somewhere else (such as :math:`H(M_1)`) is called *fixation*.

For most real-world hash functions, it's a little bit more complicated
than that. They commonly have a padding step that an attacker needs to
recreate. MD5 and SHA-1 have the same padding step. It's fairly simple,
so we'll go through it:

#. Add a 1 bit to the message.
#. Add zero bits until the length is :math:`448 \pmod {512}`.
#. Take the total length of the message, before padding, and add it as a
   64-bit integer.

For the attacker to be able to compute :math:`H(M_1 \| M_2)` given
:math:`H(M_1)`, the attacker needs to fake that padding, as well. The
attacker will actually compute :math:`H(M_1 \| G \| M_2)`, where
:math:`G` is the *glue padding*, called that way because it *glues* the
two messages together. The hard part is knowing the length of the
message :math:`M_1`.

In many systems, the attacker can actually make fairly educated guesses
about the length of :math:`M_1`, though. As an example, consider the
common (broken) example of a secret-prefix authentication code. People
send messages :math:`M_i`, authenticated using
:math:`A_i = H(S \| M_i)`, where :math:`S` is a shared secret. We'll see
(and break) this MAC algorithm in a future section.

It's very easy for the recipient to compute the same function, and
verify the code is correct. Any change to the message :math:`M_i` will
change the value of :math:`A_i` drastically, thanks to the avalanche
effect. Unfortunately, it's quite easy for attackers to forge messages.
Since the MAC is usually sent together with the original message, the
attacker knows the length of the original message. Then, the attacker
only has to guess at the length of the secret, which is often fixed as
part of the protocol, and, even if it isn't, the attacker will probably
get in a hundred tries or less. Contrast this with guessing the secret
itself, which is impossible for any reasonably chosen secret.

There are secure authentication codes that can be designed using
cryptographic hash functions: this one just isn't it. We'll see better
ones in a later chapter.

Some hash functions, particularly newer ones such as SHA-3 competition
finalists, do not exhibit this property. The digest is computed from the
internal state, instead of using the internal state directly.

This makes the SHA-3-era hash functions not only a bit more fool-proof,
but also enables them to produce simpler schemes for message
authentication. (We'll elaborate on those in a later chapter.) While
length extension attacks only affected systems where cryptographic hash
functions were being abused in the first place, there's something to be
said for preventing them anyway. People will end up making mistakes, we
might as well mitigate where we can.

TODO: say why this prevents meet in the middle attacks?

Hash trees
~~~~~~~~~~

Hash trees are trees [#]_ where each node is identified by a hash
value, consisting of its contents and the hash value of its ancestor.
The root node, not having an ancestor, simply hashes its own contents.

.. [#]
   Directed graphs, where each node except the root has exactly one
   ancestor.

This definition is very wide: practical hash trees are often more
restricted. They might be binary trees [#]_, or perhaps only leaf nodes
carry data of their own, and parent nodes only carry derivative data.
Particularly these restricted kinds are often called Merkle trees.

.. [#]
   Each non-leaf node has no more than two children

Systems like these or their variants are used by many systems,
particularly distributed systems. Examples include distributed version
control systems such as Git, digital currencies such as Bitcoin,
distributed peer-to-peer networks like Bittorrent, and distributed
databases such as Cassandra.

Remaining issues
~~~~~~~~~~~~~~~~

We've already illustrated that hash functions, by themselves, can't
authenticate messages, because anyone can compute them. Also, we've
illustrated that hash functions can't be used to secure passwords. We'll
tackle both of these problems in the following chapters.

While this chapter has focused heavily on what hash functions *can't*
do, it can't be stressed enough that they are still incredibly important
cryptographic primitives. They just happen to be commonly *abused*
cryptographic primitives.
