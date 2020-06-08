Message authentication codes
----------------------------

.. _description-6:

Description
~~~~~~~~~~~

A MAC is a small bit of information that can be used to check the
authenticity and the integrity of a message. These codes are often
called “tags”. A MAC algorithm takes a message of arbitrary length and a
secret key of fixed length, and produces the tag. The MAC algorithm also
comes with a verification algorithm that takes a message, the key and a
tag, and tells you if the tag was valid or not. (It is not always
sufficient to just recompute a tag and check if they are the same; many
secure MAC algorithms are randomized, and will produce different tags
every time you apply them.)

Note that we say “message” here instead of “plaintext” or “ciphertext”.
This ambiguity is intentional. In this book we're mostly interested in
MACs as a way to achieve authenticated encryption, so the message will
always be a ciphertext. That said, there's nothing wrong with a MAC
being applied to a plaintext message. In fact, we will be seeing
examples of secure authenticated encryption schemes that explicitly
allow for authenticated (but not encrypted) information to be sent along
with the authenticated ciphertext.

Often, when you just want to talk about the authenticity and integrity
of a particular message, it may be more practical to use a *signature
algorithm*, which we'll talk about in a later chapter. For now, all you
need to know is that the term “signature” is normally reserved for
asymmetric algorithms, whereas this chapter deals with symmetric
algorithms.

Secure MACs
^^^^^^^^^^^

We haven't quite defined yet exactly which properties we want from a
secure MAC.

We will be defending against an active attacker. The attacker will be
performing a *chosen message attack*. That means that an attacker will
ask us the tag for any number of messages :math:`m_i`, and we'll answer
truthfully with the appropriate tag :math:`t_i`.

An attacker will then attempt to produce an *existential forgery*, a
fancy way of saying that they will produce some new valid combination of
:math:`(m, t)`. The obvious target for the attacker is the ability to
produce valid tags :math:`t^{\prime}` for new messages
:math:`m^{\prime}` of their choosing. We will also consider the MAC
insecure if an attacker can compute a new, different valid tag
:math:`t^{\prime}` for a message :math:`m_i` that we previously gave
them a valid tag for.

Why does a MAC take a secret key?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you've had to deal with verifying the integrity of a message before,
you may have used checksums (like CRC32 or Adler32) or even
cryptographic hashes (like the SHA family) in order to compute a
checksum for the message (depending on the algorithm and who you're
talking to, they may have called it “hash” or “digest”, too).

Let's say that you're distributing a software package. You have some
tarballs with source code in them, and maybe some binary packages for
popular operating systems. Then you put some (cryptographically secure!)
hashes right next to them, so that anyone who downloads them can verify
the hashes and be confident that they downloaded what they think they
downloaded.

Of course, this scheme is actually totally broken. Computing those
hashes is something everyone can do. You're even relying on that fact
for your user to be able to verify their download. That also means that
an attacker that modified any of the downloads can just compute the hash
again for the modified download and save that value. A user downloading
the modified file will compute its hash and compare it against the
modified hash, and conclude that the download worked. The scheme
provided no help whatsoever against an attacker modifying the download,
either as stored, or in transit.

In order to do this securely, you would either apply a signature
algorithm to the binaries directly, or by signing the digests, as long
as the hash function used to produce the digest is secure against
second-preimage attacks. The important difference is that producing a
signature (using either a pre-shared key with your users, or,
preferably, a public-key signature algorithm) is *not* something that an
attacker can do. Only someone who has the secret keys can do that.

Combining MAC and message
~~~~~~~~~~~~~~~~~~~~~~~~~

As we've mentioned before, unauthenticated encryption is bad. That's why
we introduced MACs. Of course, for a MAC to be useful, it has to make it
to the recipient. Since we're explicitly talking about authenticating
encryption, now, we'll stop using the word “message” and instead use the
less ambiguous “plaintext” and “ciphertext”.

There are three common ways to combine a ciphertext with a MAC.

#. Authenticate and encrypt. You authenticate and encrypt the plaintext
   separately. This is how SSH does it. In symbols: :math:`C = E(K_C, P)`,
   :math:`t = MAC(K_M, P)`, and you send both ciphertext :math:`C` and tag
   :math:`t`.
#. Authenticate, then encrypt. You authenticate the plaintext and then
   encrypt the combination of the plaintext and the authentication tag.
   This is how TLS usually does it. In symbols: :math:`t = MAC(K_M, P)`,
   :math:`C = E(K_C, P \| t)`, and you only send :math:`C`. (You don't need to
   send :math:`t`, because it's already an encrypted part of :math:`C`.)
#. Encrypt, then authenticate. You encrypt the plaintext, compute the
   MAC of that ciphertext. This is how IPSec does it. In symbols:
   :math:`C = E(K_C, P)`, :math:`t = MAC(K_M, C)`, and you send both :math:`C`
   and :math:`t`.

All of these options were studied and compared extensively.
:cite:`krawczyk:order`
:cite:`bellare:maccomposition` We now know that out of all
of these, encrypt-then-authenticate is unequivocally the best option.
It's so emphatically the best option that Moxie Marlinspike, a
well-respected information security researcher, has a principle called
“The Cryptographic Doom Principle” for any system that does *not* follow
this pattern :cite:`moxie:doom`. Moxie claims that any
system that does anything before checking the MAC is doomed. Both
authenticate-and-encrypt and authenticate-then-encrypt require you to
decrypt something before you can verify the authentication.

Authenticate-then-encrypt
^^^^^^^^^^^^^^^^^^^^^^^^^

Authenticate-then-encrypt is a poor choice, but it's a subtle poor
choice. It can still be provably secure, but only under certain
conditions. :cite:`krawczyk:order`

At first sight, this scheme appears to work. Sure, you have to decrypt
before you can do anything, but to many cryptographers, including the
designers of TLS, this did not appear to pose a problem.

In fact, prior to rigorous comparative study of different composition
mechanisms, many preferred this setup. In a critique of IPSec, Schneier
and Ferguson, two veteran cryptographers, considered IPSec's use of
encrypt-then-authenticate was a flaw, preferring TLS's
authenticate-then-encrypt. :cite:`schneier:ipsec` While they
may have had a plausible (albeit mostly heuristic) argument for the
time, this criticism is completely superseded by the *provable* security
of encrypt-then-authenticate schemes. :cite:`krawczyk:order`
:cite:`bellare:maccomposition`

TODO: Explain Vaudenay CBC attack
:cite:`vaudenay:cbcpadding`

Authenticate-and-encrypt
^^^^^^^^^^^^^^^^^^^^^^^^

Authenticate-and-encrypt has some serious problems. Since the tag
authenticates the plaintext and that tag is part of the transmitted
message, an attacker will be able to recognize two plaintext messages
are the same because their tags will also be the same. This essentially
leads to the same problem we saw with ECB mode, where an attacker can
identify identical blocks. That's a serious problem, even if they can't
decrypt those blocks.

TODO: Explain how this works in SSH (see Moxie's Doom article)

A naive attempt with hash functions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Many ways of constructing MACs involve hash functions. Perhaps one of
the simplest ways you could imagine doing that is to just prefix the
message with the secret key and hash the whole thing:

.. math::

   t = H(k \| m)

This scheme is most commonly called “Prefix-MAC”, because it is a MAC
algorithm that works by using the secret key as a prefix.

The cryptographically secure hash function :math:`H` guarantees a few
things that are important to us here:

-  The tag :math:`t` will be easy to compute; the hash function
   :math:`H` itself is typically very fast. In many cases we can compute
   the common key part ahead of time, so we only have to hash the
   message itself.
-  Given any number of tags, there is no way for an attacker to “invert”
   the hash function to recover :math:`k`, which would allow them to
   forge arbitrary messages.
-  Given any number of tags, there is no way for an attacker to “rewind”
   the hash function to recover :math:`H(k)`, which may allow them to
   forge *almost* arbitrary messages.

One small caveat: we're assuming that the secret key :math:`k` has
enough entropy. Otherwise, we have the same issue that we had for
password storage using hash functions: an attacker could just try every
single :math:`k` until one of them matches. Once they've done that,
they've almost certainly found the correct :math:`k`. That's not really
a failure of the MAC though: if your secret key contains so little
entropy that it's feasible for an attacker to try all of them, you've
already lost, no matter which MAC algorithm you pick.

Breaking prefix-MAC
^^^^^^^^^^^^^^^^^^^

Despite being quite common, this MAC is actually completely insecure for
most (cryptographically secure!) hash functions :math:`H`, including
SHA-2.

As we saw in the chapter on hash functions, many hash functions, such as
MD5, SHA-0, SHA-1 and SHA-2, pad the message with a predictable padding
before producing the output digest. The output digest is the same thing
as the internal state of the hash function. That's a problem: the
attacker can use those properties to forge messages.

First, they use the digest as the internal state of the hash function.
That state matches the state you get when you hash :math:`k \| m \| p`,
where :math:`k` is the secret key, :math:`m` is the message, and
:math:`p` is that predictable padding. Now, the attacker gets the hash
function to consume some new bytes: the attacker's chosen message
:math:`m^{\prime}`. The internal state of the hash function is now what
you get when you feed it :math:`k \| m \| p \| m^{\prime}`. Then, the
attacker tells the hash function to produce a digest. Again, the hash
function appends a padding, so we're now at
:math:`k \| m \| p \| m^{\prime} \| p^{\prime}`. The attacker outputs
that digest as the tag. That is *exactly* the same thing as what happens
when you try to compute the tag for the message
:math:`m \| p \| m^{\prime}` under the secret key :math:`k`. So, the
attacker has successfully forged a tag for a new message, and, by our
definition, the MAC is insecure.

This attack is called a length extension attack, because you are
extending a valid message. The padding in the middle :math:`p`, which
started out as the padding for the original message but has become just
some data in the middle, is called *glue padding*, because it glues the
original message :math:`m` and the attacker's message :math:`m^{\prime}`
together.

This attack might sound a little academic, and far from a practical
problem. We may have proven that the MAC is insecure by our definition,
but the only tags the attacker can successfully forge are for very
limited modifications of real messages. Specifically, the attacker can
only forge tags for a message that consists of a message we sent,
followed by some binary junk, followed by something the attacker
chooses. However, it turns out that for many systems, this is plenty to
result in real breaks. Consider the following Python code that parses a
sequence of key-value pairs that look like ``k1=v1&k2=v2&...``: [#]_

.. [#]
   I realize there are briefer ways to write that function. I am trying
   to make it comprehensible to most programmers; not pleasing to
   advanced Pythonistas.

.. code:: python

   def parse(s):
       pairs = s.split("&")
       parsed = {}
       for pair in pairs:
           key, value = pair.split("=")
           parsed[key] = value
       return parsed

The parsing function only remembers the last value for a given key:
previous values in the dictionary are overwritten. As a result, an
attacker mounting a length extension attack can effectively control the
parsed dictionary entirely.

If you're thinking that this code has many issues; sure, it does. For
example, it doesn't handle escaping correctly. But even if it did, that
wouldn't really fix the length extension attack problem. Most parsing
functions will perfectly happily live with that binary junk in the
middle. Hopefully it convinces you that there is in fact a pretty good
chance that an attacker can produce messages with valid tags that say
something entirely different from what you intended.

The prefix-MAC construction is actually secure with many current
(SHA-3-era) hash functions, such as Keccak and BLAKE(2). The
specifications for these hash functions even recommend it as a secure
and fast MAC. They use various techniques to foil length extension
attacks: for example, BLAKE keeps track of the number of bits that have
been hashed so far, while BLAKE2 has a finalization flag that marks a
specific block as the last.

Variants
^^^^^^^^

Issues with prefix-MAC has tempted people to come up with all sorts of
clever variations. For example, why not add the key to the end instead
of the beginning (:math:`t = H(m \| k)`, or “suffix-MAC”, if you will)?
Or maybe we should append the key to both ends for good measure
(:math:`t = H(k \| m \| k)`, “sandwich-MAC” perhaps?)?

For what it's worth, both of these are at least better than prefix-MAC,
but both of these have serious issues. For example, a suffix-MAC system
is more vulnerable to weaknesses in the underlying hash function; a
successful collision attack breaks the MAC. Sandwich-MAC has other, more
complex issues.

Cryptography has produced much stronger MACs, which we'll see in the
next few sections. There are no good reasons not to use them.

HMAC
~~~~

HMAC is a standard to produce a MAC with a cryptographic hash function
as a parameter. It was introduced in 1996 in a paper by Bellare, Canetti
and Krawczyk. Many protocols at the time implemented their own attempt
at message authentication using hash functions. Most of these attempts
failed. The goal of that paper specifically was to produce a provably
secure MAC that didn't require anything beyond a secret key and a hash
function.

One of the nice features of HMAC is that it has a fairly strong security
proof. As long as the underlying hash function is a pseudorandom
function, HMAC itself is also a pseudorandom function. The underlying
hash function doesn't even have to be collision resistant for HMAC to be
a secure MAC. :cite:`hmac:proof2` This proof was introduced
after HMAC itself, and matched real-world observations: even though MD5
and to a lesser extent SHA-0 had serious collision attacks, HMAC
constructions built from those hash functions still appeared to be
entirely secure.

The biggest difference between HMAC and prefix-MAC or its variants is
that the message passes through a hash function twice, and is combined
with the key before each pass. Visually, HMAC looks like this:

.. figure:: ./Illustrations/HMAC/HMAC.svg
   :align: center

The only surprising thing here perhaps are the two constants
:math:`p_{inner}` (the inner padding, one hash function's block length
worth of ``0x36`` bytes) and :math:`p_{outer}` (the outer padding, one
block length worth of ``0x5c`` bytes). These are necessary for the
security proof of HMAC to work; their particular values aren't very
important, as long as the two constants are different.

The two pads are XORed with the key before use. The result is either
prepended to the original message (for the inner padding
:math:`p_{inner}`) or to the intermediate hash output (for the outer
padding :math:`p_{outer}`). Because they're prepended, the internal
state of the hash function after processing the prefixes can be computed
ahead of time, shaving a few cycles off the MAC computation time.

One-time MACs
~~~~~~~~~~~~~

So far, we've always assumed that MAC functions can be used with a
single key to produce secure MACs for a very large number of messages.
By contrast, :term:`one-time MAC`\s are MAC functions that can only securely be
used once with a single key. That might sound like a silly idea, since
we've already talked about regular secure MACs. An algorithm that only
works once just seems objectively worse. However, they have several big
advantages:

-  They can be incredibly fast to evaluate, even for very large
   messages.
-  They have a compelling security proof based on the information
   content of the tag.
-  A construction exists to turn a :term:`one-time MAC` into a secure
   multiple-use MAC, removing the principal problem.

A typical simple example of such :term:`one-time MAC`\s consists of a simple
multiplication and addition modulo some large prime :math:`p`. In this
case, the secret key consists of two truly random numbers :math:`a` and
:math:`b`, both between 1 and :math:`p`.

.. math::

   t \equiv m \cdot a + b \pmod p

This simple example only works for one-block messages :math:`m`, and
some prime :math:`p` slightly bigger than the biggest :math:`m`. It can
be extended to support bigger messages :math:`M` consisting of blocks
:math:`m_i` by using a message-specific polynomial :math:`P`:

.. math::

   t \equiv \underbrace{(m_n \cdot a^n + \cdots + m_1 \cdot a)}_{P(M, a)} + b \pmod p

This might look like a lot of computation, but this polynomial can be
efficiently evaluated by iteratively factoring out the common factor
:math:`a` (also known as Horner's rule):

.. math::

   P(M, a) \equiv a \cdot (a \cdot (a \cdot (\cdots) + m_2) + m_1) + b \pmod p

By computing each multiplication modulo :math:`p`, the numbers will
remain conveniently small.

In many ways, a :term:`one-time MAC` is to authentication what a one-time pad is
to encryption. The security argument is similar: as long as the key is
only used once, an attacker learns no information about the key or the
message, because they are being irreversibly mixed. This demonstrates
that the MAC is secure against attackers trying to produce existential
forgeries, even when that attacker has infinite computational power.

Also like a one-time pad, the security argument relies on two very
important properties about the keys :math:`a, b`:

-  They have to be truly random.
-  They have to be used at most once.

Re-using :math:`a` and :math:`b`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We'll illustrate that our example MAC is insecure if it is used to
authenticate two messages :math:`m_1, m_2` with the same key
:math:`(a, b)`:

.. math::

   \begin{aligned}
   t_1 &\equiv m_1 \cdot a + b \pmod p \\
   t_2 &\equiv m_2 \cdot a + b \pmod p
   \end{aligned}

An attacker can reconstruct :math:`a, b` with some simple modular
arithmetic:  [#]_

.. [#]
   For a refresher on modular arithmetic, including an explanation of
   the modular inverse, please refer to :ref:`the appendix <modular-arithmetic>`.

.. math::

   \begin{aligned}
     t_1 - t_2 &\equiv (m_1 \cdot a + b) - (m_2 \cdot a + b) \pmod p \\
     &\Downarrow \text{(remove parentheses)} \\
     t_1 - t_2 &\equiv m_1 \cdot a + b - m_2 \cdot a - b \pmod p \\
     &\Downarrow \text{($b$ and $-b$ cancel out)} \\
     t_1 - t_2 &\equiv m_1 \cdot a - m_2 \cdot a \pmod p \\
     &\Downarrow \text{(factor out $a$)} \\
     t_1 - t_2 &\equiv a \cdot (m_1 - m_2) \pmod p \\
     &\Downarrow \text{(flip sides, multiply by inverse of $(m_1 - m_2)$)} \\
     a &\equiv (t_1 - t_2)(m_1 - m_2)^{-1} \pmod p
   \end{aligned}

Plugging :math:`a` into either the equation for :math:`t_1` or
:math:`t_2` gets :math:`b`:

.. math::

   \begin{aligned}
   t_1 &\equiv m_1 \cdot a + b \pmod p \\
   &\Downarrow \text{(reorder terms)}\\
   b &\equiv t_1 - m_1 \cdot a \pmod p
   \end{aligned}

As you can see, as with one-time pads, re-using the key even once leads
to a complete failure of the cryptosystem to preserve privacy or
integrity, as the case may be. As a result, :term:`one-time MAC`\s are a bit
dangerous to use directly. Fortunately, this weakness can be solved with
a construction called a :term:`Carter-Wegman MAC`, which we'll see in the next
section.

Carter-Wegman MAC
~~~~~~~~~~~~~~~~~

As we've already stated, the obvious problem with :term:`one-time MAC`\s is their
limited practicality. Fortunately, it turns out that there is a
construction, called a :term:`Carter-Wegman MAC`, that turns any secure one-time
MAC into a secure many-time MAC while preserving most of the performance
benefit.

The idea behind a :term:`Carter-Wegman MAC` is that you can use a :term:`one-time MAC`
:math:`O` to produce a tag for the bulk of the data, and then encrypt a
:term:`nonce` :math:`n` with a pseudorandom function :math:`F`, such as a block
cipher, to protect that one-time tag:

.. math::

   CW((k_1, k_2), n, M) = F(k_1, n) \xor O(k_2, M)

As long as :math:`F` is a secure pseudorandom function, the :term:`nonce`'s
encryption is totally unpredictable. In the eyes of an attacker, that
means the XOR operation will randomly flip the bits of the :term:`one-time MAC`
tag :math:`O(k_2, M)`. Because this masks the real value of the one-time
MAC tag, the attacker can not perform the algebraic tricks we saw for
:term:`one-time MAC`\s recovering the key when it is used more than once.

Keep in mind that while :term:`Carter-Wegman MAC`\s take two distinct keys
:math:`k_1` and :math:`k_2`, and that :term:`Carter-Wegman MAC`\s are related to
:term:`one-time MAC`\s, some of which also take two distinct keys :math:`a` and
:math:`b`, they are not the same two keys. The Carter-Wegman MAC's
:math:`k_2` is the only key passed to the fast :term:`one-time MAC` :math:`O`.
If that fast :term:`one-time MAC` is our earlier example that takes two keys
:math:`a` and :math:`b`, that :math:`k_2` would have to get split up
into those two keys. The :term:`Carter-Wegman MAC` key would then be
:math:`(k_1, k_2) = (k_1, (a, b))`.

You can tell how a :term:`Carter-Wegman MAC` exploits the benefits of both kinds
of MACs by considering the two terms of the equation separately. In
:math:`F(k_1, n)`, :math:`F` is just a regular pseudorandom function,
such as a block cipher. It is quite slow by comparison to the one-time
MAC. However, its input, the :term:`nonce`, is very small. The unpredictable
output of the block cipher masks the output of the :term:`one-time MAC`. In the
second term, :math:`O(k_2, M)`, the large input message :math:`M` is
only handled by the very fast :term:`one-time MAC` :math:`O`.

These constructions, in particular Poly1305-AES, currently represent
some of the state of the art in MAC functions. The paper
(:cite:`umac`) and RFC (:cite:`rfc4418`) for an
older, related MAC function called UMAC may also be good sources of
extra background information, since they go into extensive details of
the hows and whys of a practical :term:`Carter-Wegman MAC`.

Authenticated encryption modes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

So far, we've always clearly distinguished encryption from
authentication, and explained the need for both. The majority of secure
connections that are set up every day have that distinction as well:
they treat encryption and authentication as fundamentally different
steps.

Alternatively, we could make authentication a fundamental part of the
:term:`mode of operation`. After all, we've already seen that unauthenticated
encryption is virtually never what you want; it is, at best, something
you occasionally have to live with. It makes sense to use constructions
that not only guarantee the privacy of an arbitrary stream, but also its
integrity.

As we've already seen, many of the methods of composing authentication
and encryption are inherently insecure. By doing that in a fixed, secure
way such as a properly designed authenticated encryption mode, an
application developer no longer has to make that choice, which means
they also can't inadvertently make the *wrong* choice.

AEAD
^^^^

AEAD is a feature of certain modes of authenticated encryption. Such
modes of operation are called :term:`AEAD mode`\s. It starts with the premise
that many messages actually consist of two parts:

-  The actual content itself
-  Metadata: data *about* the content

In many cases the metadata should be plaintext, but the content itself
should be encrypted. The entire message should be authenticated: it
should not be possible for an attacker to mess with the metadata and
have the resulting message still be considered valid.

Consider an e-mail alternative as an example cryptosystem. The metadata
about the content might contain the intended recipient. We definitely
want to encrypt and authenticate the content itself, so that only the
recipient can read it. The metadata, however, has to be in plaintext:
the e-mail servers performing the message delivery have to know which
recipient to send the message to.

Many systems would leave this metadata unauthenticated, allowing
attackers to modify it. In our case, that looks like it may just lead to
messages being delivered to the wrong inbox. That also means that an
attacker can force e-mail to be delivered to the wrong person, or not
delivered at all.

:term:`AEAD mode`\s address this issue by providing a specified way to add
metadata to encrypted content, so that the whole of the encrypted
content and the metadata is authenticated, and not the two pieces
separately:

.. figure:: Illustrations/AEAD/AEAD.svg
   :align: center

OCB mode
~~~~~~~~

.. advanced::

Usually, you will want to use a much more high level cryptosystem, such as OpenPGP, NaCl or TLS.

:term:`OCB mode` is an :term:`AEAD mode` of operation. It is one of the earliest
developed :term:`AEAD mode`\s.

.. figure:: Illustrations/OCB/Encryption.svg
   :align: center

As you can see, most of this scheme looks quite similar to
:term:`ECB mode`. The name OCB is quite similar to electronic codebook,
as well. OCB does not share the security issues ECB mode has, however,
as there are several important differences, such as the offsets
:math:`\Delta_i` introduced in each individual block encryption.

Being an :term:`AEAD mode`, :term:`OCB mode` provides a cryptographically secure
authentication tag :math:`t`, which is built from :math:`X`, a very
simple (not cryptographically secure by itself) checksum of the
plaintext. There is also another, separate tag :math:`t_a`, which
authenticates the AEAD associated data. That associated data tag
:math:`t_a` is computed as follows:

.. figure:: Illustrations/OCB/Auth.svg
   :align: center

This design has a number of interesting properties. For example, it is
very fast: only requiring roughly one block cipher operation per
encrypted or associate data block, as well as one additional block
cipher operation for the final tag. The offsets (:math:`\Delta_i`) are
also extremely easy to compute. The checksum block :math:`X` is just all
of the plaintext blocks :math:`P_i` XORed together. Finally, :term:`OCB mode` is
easy to compute in parallel; only the final authentication tag is
dependent on all the preceding information.

:term:`OCB mode` also comes with a built-in padding scheme: it behaves slightly
differently when the plaintexts or authentication text is not exactly a
multiple of the block size. This means that, unlike with PKCS#5/PKCS#7
padding, there isn't an entire block of “wasted” padding if the
plaintext happens to be a multiple of the block size.

Despite having several interesting properties going for it, :term:`OCB mode` has
not received as much attention as some of the alternatives; one of the
main reasons being that it is patent encumbered. Even though a number of
patent licenses are available, including a free-of-charge one for open
source software, this does not appear to have significantly impacted how
much :term:`OCB mode` is used in the field. :cite:`ocb:license`

GCM mode
~~~~~~~~

.. advanced::

Usually, you will want to use a much more high level cryptosystem, such as OpenPGP, NaCl or TLS.

:term:`GCM mode` is an :term:`AEAD mode` with an unfortunate case of RAS (redundant
acronym syndrome) syndrome: GCM itself stands for “Galois Counter Mode”.
It is formalized in a NIST Special Publication :cite:`gcm`
and roughly boils down to a combination of classical CTR mode with a
:term:`Carter-Wegman MAC`. That MAC can be used by itself as well, which is
called :term:`GMAC`.

Authentication
^^^^^^^^^^^^^^

:term:`GCM mode` (and by extension :term:`GMAC`)
