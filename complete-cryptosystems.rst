Complete cryptosystems
======================

SSL and TLS
-----------

.. _description-9:

Description
~~~~~~~~~~~

SSL, short for Secure Socket Layer, is a cryptographic protocol
originally introduced by Netscape Communications [28]_ for securing
traffic on the Web. The standard is now superseded by TLS (Transport
Layer Security), a standard publicized in RFCs by the IETF. The term SSL
is still commonly used, even when the speaker actually means a TLS
connection. From now on, this book will only use the term TLS, unless we
really mean the old SSL standard.

Its first and foremost goal is to transport bytes securely, over the
Internet or any other insecure medium. :cite:`tls12` It's a
hybrid cryptosystem: it uses both symmetric and asymmetric algorithms in
unison. For example, asymmetric algorithms such as signature algorithms
can be used to authenticate peers, while public key encryption
algorithms or Diffie-Hellman exchanges can be used to negotiate shared
secrets and authenticate certificates. On the symmetric side, stream
ciphers (both native ones and block ciphers in a mode of operation) are
used to encrypt the actual data being transmitted, and MAC algorithms
are used to authenticate that data.

TLS is the world's most common cryptosystem, and hence probably also the
most studied. Over the years, many flaws have been discovered in SSL and
TLS, despite many of the world's top cryptographers contributing to and
examining the standard [29]_. As far as we know, the current versions of
TLS are secure, or at least can be configured to be secure.

Handshakes
~~~~~~~~~~

TODO: explain a modern TLS handshake

Downgrade attacks
^^^^^^^^^^^^^^^^^

SSL 2.0 made the mistake of not authenticating handshakes. This made it
easy to mount downgrade attacks. A downgrade attack is a
man-in-the-middle attack where an attacker modifies the handshake
messages that negotiate which ciphersuite is being used. That way, he
can force the clients to set up the connection using an insecure block
cipher, for example.

Due to cryptographic export restrictions at the time, many ciphers were
only 40 or 56 bit. Even if the attacker couldn't break the best
encryption both client and server supported, he could probably break the
weakest, which is all that is necessary for a downgrade attack to
succeed.

This is one of the many reasons that there is an explicit
RFC :cite:`turner:prohibitssl20` prohibiting new TLS
implementations from having SSL v2.0 support.

Certificate authorities
~~~~~~~~~~~~~~~~~~~~~~~

TLS certificates can be used to authenticate peers, but how do we
authenticate the certificate? My bank may very well have a certificate
claiming to be that particular bank, but how do I know it's actually my
bank, and not just someone pretending to be my bank? Why should I trust
this particular certificate? As we've seen when we discussed these
algorithms, anyone can generate as many key pairs as they'd like.
There's nothing stopping someone from generating a key pair pretending
to be your bank.

When someone actually tries to use a certificate to impersonate a bank,
real browsers don't believe them. They notify the user that the
certificate is untrusted. They do this using the standard TLS trust
model of certificate authorities. TLS clients come with a list of
trusted certificate authorities, commonly shipped with your operating
system or your browser. These are special, trusted certificates, that
are carefully guarded by their owners.

For a fee, these owners will use their certificate authority to sign
other certificates. The idea is that the certificate authority wouldn't
sign a certificate for Facebook or a bank or anyone else, unless you
could prove you're actually them.

When a TLS client connects to a server, that server provides a
certificate chain. Typically, their own certificate is signed by an
intermediary CA certificate, which is signed by another, and another,
and one that is signed by a trusted root certificate authority. Since
the client already has a copy of that root certificate, they can verify
the signature chain starting with the root.

Your fake certificate doesn't have a chain leading up to a trusted root
certificate, so the browser rejects it.

TODO: Explain why this is a total racket

Self-signed certificates
~~~~~~~~~~~~~~~~~~~~~~~~

Client certificates
~~~~~~~~~~~~~~~~~~~

In TLS, certificates are usually only used to identify the server. This
satisfies a typical use case: users want to communicate securely with
their banks and e-mail providers, and the certificate authenticates the
service they're talking to. The service usually authenticates the user
using passwords, and, occasionally, two-factor authentication.

In public-key schemes we've seen so far, all peers typically had one or
more key pairs of their own. There's no reason users can't have their
own certificates, and use them to authenticate to the server. The TLS
specification explicitly supports client certificates. This feature is
only rarely used, even though it clearly has very interesting security
benefits.

The main reason for that is probably rooted in the poor user experience.
There are no systems that rely on client certificates that are easy to
use for non-technical people. Since there are few such systems, even
tech-savvy people don't know about them, which means new systems aren't
created.

Client certificates are a great solution for when you control both ends
of the wire and want to securely authenticate both peers in a TLS
connection. By producing your own certificate authority, you can even
sign these client certificates to authenticate them.

Perfect forward secrecy
~~~~~~~~~~~~~~~~~~~~~~~

Historically, the most common way to agree on the pre-master secret is
for the client to select a random number and encrypt it, typically using
RSA. This has a few nice properties. For example, it means the server
can make do with less entropy: since the random bits are handed to the
server by the client, the server doesn't need to produce any
cryptographically random bits. It also makes the handshake slightly
faster, since there's no need for back-and-forth communication to agree
on a shared secret.

However, it has one major flaw. Suppose an attacker gets access to the
server's private key. Perhaps they managed to factor the modulus of the
RSA key, or perhaps they broke in and stole it, or perhaps they used
legal force to get the owner to hand over the key. Regardless of how
they acquired it, getting access to the key allows the attacker to
decrypt all past communication. The key allows them to decrypt the
encrypted pre-master secrets, which allows them to derive all of the
symmetric encryption keys, and therefore decrypt everything.

There are obvious alternatives to this scheme. We've already seen
Diffie-Hellman key exchange, allowing two peers to agree on secret keys
over an insecure medium. TLS allows for peers to agree on the pre-master
secret using a Diffie-Hellman exchange, either based on discrete logs or
elliptic curves.

Assuming both peers discard the keys after use like they're supposed to,
getting access to the secret keys wouldn't allow an attacker to decrypt
previous communication. That property is called *perfect forward
secrecy*. The term “perfect” is a little contested, but the term
“forward” means that communications can't be decrypted later if the
long-term keys (such as the server's private key) fall into the wrong
hands.

Of course, this is only true if Diffie-Hellman exchanges are secure. If
an attacker has a significant mathematical and computational advantage
over everyone else, such as an algorithm for solving the discrete log
problem more efficiently than thought possible, combined with many data
centers filled with number-crunching computers, it's possible that
they'll break the key exchange itself.

.. _attacks-1:

Attacks
~~~~~~~

As with most attacks, attacks on TLS can usually be grouped into two
distinct categories:

#. Attacks on the protocol itself, such as subverting the CA mechanism;
#. Attacks on a particular implementation or cipher, such as
   cryptanalytic attacks exploiting weaknesses in RC4, or timing attacks
   in a particular AES implementation.

Unfortunately, SSL/TLS has had many successful attacks in both
categories. This section is particularly about the latter.

CRIME and BREACH
^^^^^^^^^^^^^^^^

CRIME [30]_ is an attack by the authors of BEAST. It's an innovative
side channel attack that relies on TLS compression leaking information
about secrets in the plaintext. In a related attack called BREACH [31]_,
the attackers accomplish the same effect using HTTP compression. That
was predicted by the authors of the original paper, but the BREACH
authors were the first to demonstrate it as a practical attack. The
BREACH attack was more practically applicable, though: HTTP compression
is significantly more common than TLS compression.

Both of these rely on encryption of a compressed plaintext, and their
mechanisms are virtually identical: only the specific details related to
HTTP compression or TLS compression are relevant. The largest difference
is that with TLS compression, the entire stream can be attacked; with
HTTP compression, only the body is compressed, so HTTP headers are safe.
Since the attacks are otherwise extremely similar, we'll just talk about
how the attack works in the abstract, by explaining how attackers can
learn information about the plaintext if it is compressed before
encryption.

The most common algorithm used to compress both HTTP and
TLS :cite:`rfc3749:tlscompression` is called DEFLATE. The
exact mechanics of DEFLATE aren't too important, but the important
feature is that byte sequences that occur more than once can be
efficiently stored. When a byte sequence recurs [32]_, instead of
recording the same sequence, a reference is provided to the previous
sequence: instead of repeating the sequence, it says “go back and look
at the thing I wrote N bytes ago”.

Suppose an attacker can control the plaintext. For example, the attacker
injects an invisible iframe [33]_ or some JavaScript code that fires off
many requests. The attacker needs some way to inject their guess of the
secret so that their guess occurs in the plaintext, such as the query
parameters [34]_. Usually, they can prefix their guess with something
known. Suppose they're trying to intercept an authentication token being
supplied in the body of the web page:

.. code:: html

   <input type="hidden"
          name="csrf-token"
          value="TOKEN_VALUE_HERE">

… they can prefix the guess with the known part of that. In this case,
it's a CSRF token; a random token selected by the server and given to
the client. This token is intended to prevent malicious third party
websites from using the ambient authority present in the browser (such
as session cookies) to make authenticated requests. Without a CSRF
token, a third party website might just make a request to the vulnerable
website; the web browser will provide the stored cookie, and the
vulnerable website will mistake that for an authenticated request.

The attacker makes guesses at the value of the token, starting with the
first byte, and moving on one byte at a time. [35]_ When they guess a
byte correctly, the ciphertext will be just a little shorter: the
compression algorithm will notice that it's seen this pattern before,
and be able to compress the plaintext before encrypting. The plaintext,
and hence the compressed ciphertext, will therefore be smaller. They can
do this directly when the connection is using a stream cipher or a
similar construction such as CTR mode, since they produce ciphertexts
that are exactly as long as the plaintexts. If the connection is using a
block-oriented mode such as CBC mode, the difference might get lost in
the block padding. The attacker can solve that by simply controlling the
prefix so that the difference in ciphertext size will be an entire
block.

Once they've guessed one byte correctly, they can move on to the next
byte, until they recover the entire token.

This attack is particularly interesting for a number of reasons. Not
only is it a completely new *class* of attack, widely applicable to many
cryptosystems, but compressing the plaintext prior to encryption was
actively recommended by existing cryptographic literature. It doesn't
require any particularly advanced tools: you only need to convince the
user to make requests to a vulnerable website, and you only need to be
able to measure the size of the responses. It's also extremely
effective: the researchers that published BREACH report being able to
extract secrets, such as CSRF tokens, within one minute.

In order to defend against CRIME, disable TLS compression. This is
generally done in most systems by default. In order to defend against
BREACH, there are a number of possible options:

-  Don't allow the user to inject arbitrary data into the request.
-  Don't put secrets in the response bodies.
-  Regenerate secrets such as CSRF tokens liberally, for example, each
   request.

It's a bad idea to simply unconditionally turn off HTTP compression.
While it does successfully stop the attack, HTTP compression is a
critical tool for making the Web faster.

Web apps that consist of a static front-end (say, using HTML5, JS, CSS)
and that only operate using an API, say, JSON over REST, are
particularly easy to immunize against this attack. Just disable
compression on the channel that actually contains secrets. It makes
things slower, of course, but at least the majority of data can still be
served over a CDN.

HSTS
~~~~

HSTS is a way for web servers to communicate that what they're saying
should only ever be transferred over a secure transport. In practice,
the only secure transport that is ever used for HTTP is TLS.

Using HSTS is quite simple; the web server just adds an extra
``Strict-Transport-Security`` header to the response. The header value
contains a maximum age (``max-age``), which determines how long into the
future the browser can trust that this website will be HSTS-enabled.
This is typically a large value, such as a year. Browsers successfully
remembering that a particular host is HSTS-enabled is very important to
the effectiveness of the scheme, as we'll see in a bit. Optionally, the
HSTS header can include the ``includeSubDomains`` directive, which
details the scope of the HSTS policy. :cite:`hsts`

There are several things that a conforming web browser will do when
communicating with an HSTS-enabled website:

-  Whenever there is any attempt to make any connection to this website,
   it will always be done over HTTPS. The browser does this completely
   by itself, *before* making the request to the website.
-  If there is an issue setting up a TLS connection, the website will
   not be accessible, instead of simply displaying a warning.

Essentially, HSTS is a way for websites to communicate that they only
support secure transports. This helps protect the users against all
sorts of attacks including both passive eavesdroppers (that were hoping
to see some credentials accidentally sent in plaintext), and active
man-in-the-middle attacks such as SSL stripping.

HSTS also defends against mistakes on the part of the web server. For
example, a web server might accidentally pull in some executable code,
such as some JavaScript, over an insecure connection. An active attacker
that can intercept and modify that JavaScript would then have complete
control over the (supposedly secure) web site.

As with many TLS improvements, HSTS is not a panacea: it is just one
tool in a very big toolbox of stuff that we have to try and make TLS
more secure. HSTS only helps to ensure that TLS is actually used; it
does absolutely nothing to prevent attacks against TLS itself.

HSTS can suffer from a chicken-or-egg problem. If a browser has never
visited a particular HSTS-enabled website before, it's possible that the
browser doesn't know that the website is HSTS-enabled yet. Therefore,
the browser may still attempt a regular HTTP connection, vulnerable to
an SSL stripping attack. Some browsers have attempted to mitigate this
issue by having browsers come pre-loaded with a list of HSTS websites.

Certificate pinning
~~~~~~~~~~~~~~~~~~~

Certificate pinning is an idea that's very similar to HSTS, taken a
little further: instead of just remembering that a particular server
promises to support HTTPS, we'll remember information about their
certificates (in practice, we'll remember a hash of the public key).
When we connect to a server that we have some stored information about,
we'll verify their certificates, making it much harder for an impostor
to pretend to be the website we're connecting to using a different
certificate.

Browsers originally implemented certificate pinning by coming shipped
with a list of certificates from large, high-profile websites. For
example, Google included whitelisted certificates for all of their
services in their Chrome browser.

Secure configurations
~~~~~~~~~~~~~~~~~~~~~

In this section, we are only talking about configuration options such as
which ciphers to use, TLS/SSL versions, etc. We're specifically *not*
talking about TLS configurations in the sense of trust models, key
management, etc.

There are several issues with configuring TLS securely:

#. Often, the defaults are unsafe, and people are unaware that they
   should be changed.
#. The things that constitute a secure TLS configuration can change
   rapidly, because cryptanalysis and practical attacks are continuously
   improving.
#. Old clients that still need to be supported sometimes mean that you
   have to hang on to broken configuration options.

A practical example of some of these points coming together is the BEAST
attack. That attack exploited weaknesses in CBC ciphersuites in TLSv1.0,
which were parts of the default ciphersuite specifications everywhere.
Many people recommended defending against it by switching to RC4. RC4
was already considered cryptographically weak, later cryptanalysis
showed that RC4 was even more broken than previously suspected. The
attack had been known for years before being practically exploited; it
was already fixed in TLSv1.1 in 2006, years before the BEAST paper being
published. However, TLSv1.1 had not seen wide adoption.

Good advice necessarily changes over time, and it's impossible to do so
in a persistent medium such as a book. Instead, you should look at
continuously updated third party sources such as `Qualys SSL Labs
<https://www.ssllabs.com/>`_. They provide tests for both SSL clients
and servers, and extensive advice on how to improve configurations.

That said, there are certainly some general things we want from a TLS
configuration.

TODO: say stuff we generally want from TLS configurations

TODO: http://tools.ietf.org/html/draft-agl-tls-chacha20poly1305-01

OpenPGP and GPG
---------------

.. _description-10:

Description
~~~~~~~~~~~

OpenPGP is an open standard that describes a method for encrypting and
signing messages. GPG is the most popular implementation of that
standard [36]_, available under a free software license.

Unlike TLS, which focuses on data in motion, OpenPGP focuses on data at
rest. A TLS session is active: bytes fly back and forth as the peers set
up the secure channel. An OpenPGP interaction is, by comparison, static:
the sender computes the entire message up front using information shared
ahead of time. In fact, OpenPGP doesn't insist that anything is *sent*
at all: for example, it can be used to sign software releases.

Like TLS, OpenPGP is a hybrid cryptosystem. Users have key pairs
consisting of a public key and a private key. Public key algorithms are
used both for signing and encryption. Symmetric key algorithms are used
to encrypt the message body; the symmetric key itself is protected using
public-key encryption. This also makes it easy to encrypt a message for
multiple recipients: only the secret key has to be encrypted multiple
times.

The web of trust
~~~~~~~~~~~~~~~~

Earlier, we saw that TLS typically uses trusted root certificates to
establish that a particular peer is who they claim to be. OpenPGP does
not operate using such trusted roots. Instead, it relies on a system
called the Web of Trust: a friend-of-a-friend honor system that relies
on physical meetings where people verify identities.

The simplest case is a directly trusted key. If we meet up in person, we
can verify each other's identities. Perhaps we know each other, or
perhaps we'd check some form of identification. Then, we sign each
other's keys.

Because I know the key is yours, I know that you can read the messages
encrypted by it, and the other way around. Provided you don't share your
key, I know that *only* you can read those messages. No-one can replace
my copy of your key, because they wouldn't be able to forge my signature
on it.

There's a direct trust link between the two of us, and we can
communicate securely.

.. figure:: ./Illustrations/PGP/WebOfTrustDirect.svg
   :align: center

A slightly more complicated case is when a friend of yours would like to
send me a message. We've never met: he's never signed my key, nor have I
signed theirs. However, I have signed your key, and vice versa. You've
signed your friend's key, and vice versa. Your friend can choose to
leverage your assertion that I'm indeed the person in possession of that
key you signed, and use that to communicate with me securely.

.. figure:: ./Illustrations/PGP/WebOfTrustIndirect.svg
   :align: center

You might wonder how your friend would ever see signatures that you
placed on my key. This is because keys and signatures are typically
uploaded to a network of key servers, making them freely available to
the world.

The above system can be extended to multiple layers of friends. It
relies in no small part in communities being linked by signatures, which
is why many community events include key signing parties, where people
sign each other's keys. For large events, such as international
programming conferences, this system is very effective. The main
weakness in this system are “islands” of trust: individuals or small
groups with no connections to the rest of the web.

.. figure:: ./Illustrations/PGP/WebOfTrustIslands.svg
   :align: center

Of course, this is only the default way to use OpenPGP. There's nothing
stopping you from shipping a particular public key as a part of a
software package, and using that to sign messages or verify messages.
This is analogous to how you might want to ship a key with a client
certificate, or a custom root CA certificate, with TLS.

Off-The-Record Messaging (OTR)
------------------------------

.. _description-11:

Description
~~~~~~~~~~~

OTR messaging is a protocol for securing instant messaging communication
between people :cite:`borisov:otr`. It intends to be the
online equivalent of a private, real-life conversation. It encrypts
messages, preventing eavesdroppers from reading them. It also
authenticates peers to each other, so they know who they're talking to.
Despite authenticating peers, it is designed to be deniable:
participants can later deny to third parties anything they said to each
other. It is also designed to have perfect forward secrecy: even a
compromise of a long-term public key pair doesn't compromise any
previous conversations.

The deniability and perfect forward secrecy properties are very
different from those of other systems such as OpenPGP. OpenPGP
intentionally guarantees non-repudiability. It's a great property if
you're signing software packages, talking on mailing lists or signing
business invoices, but the authors of OTR argue that those aren't
desirable properties for the online equivalent of one-on-one
conversations. Furthermore, OpenPGP's static model of communication
makes the constant key renegotiation to facilitate OTR's perfect forward
secrecy impossible.

OTR is typically configured opportunistically, which means that it will
attempt to secure any communication between two peers, if both
understand the protocol, without interfering with communication where
the other peer does not. The protocol is supported in many different
instant messaging clients either directly, or with a plugin. Because it
works over instant messages, it can be used across many different
instant messaging protocols.

A peer can signal that they would like to speak OTR with an explicit
message, called the OTR Query message. If the peer is just willing to
speak OTR but doesn't require it, they can optionally invisibly add that
information to a plaintext message. That happens with a clever system of
whitespace tags: a bunch of whitespace such as spaces and tab characters
are used to encode that information. An OTR-capable client can interpret
that tag and start an OTR conversation; an client that isn't OTR-capable
just displays some extra whitespace.

OTR uses many of the primitives we've seen so far:

-  Symmetric key encryption (AES in CTR mode)
-  Message authentication codes (HMAC with SHA-1)
-  Diffie-Hellman key exchange

OTR also utilizes another mechanism, called the SMP, to check if peers
arrived at the same shared secret.

.. _key-exchange-1:

Key exchange
~~~~~~~~~~~~

In OTR, AKE relies heavily on Diffie-Hellman key exchange, extended with
a significant number of extra, interlocking checks. The Diffie-Hellman
exchange itself uses a fixed 1536-bit prime with a fixed generator
:math:`g`.

We suppose that two participants, named Alice and Bob want to
communicate and are willing to exchange sensitive data with each other.
Alice and Bob have a long-term DSA authentication key pair each, which
we'll call (:math:`p_A, s_A)` and :math:`(p_B, s_B)` respectively.

The protocol also relies on a number of other primitives:

-  A 128-bit block cipher. In OTR, this is always AES. In this section,
   we'll call block cipher encryption and decryption :math:`E` and
   :math:`D`, respectively.
-  A hash function, :math:`H`. In OTR, this is SHA1.
-  A message authentication code, :math:`M`. In OTR, this is HMAC-SHA1.
-  A signing function, :math:`S`.

Commit message
^^^^^^^^^^^^^^

Initially Alice and Bob are in a protocol state where they wait for the
peer to initiate an OTR connection, and advertise their own capability
of speaking OTR.

Let's suppose that Bob chooses to initiate an OTR conversation with
Alice. His client sends an OTR Commit Message, and then transitions to a
state where he waits for a reply from from Alice's client.

To send a commit message, a client picks a random 128-bit value
:math:`r` and a random 320-bit (or larger) Diffie-Hellman secret
:math:`x`. It then sends :math:`E(r, g^x)` and :math:`H(g^x)` to the
peer.

Key message
^^^^^^^^^^^

Alice's client has received Bob's client's advertisement to start an OTR
session. Her client replies with a key message, which involves creating
a new Diffie-Hellman key pair. She picks a 320-bit (or larger)
Diffie-Hellman secret :math:`y` and sends :math:`g^y` to Bob.

Reveal Signature Message
^^^^^^^^^^^^^^^^^^^^^^^^

Now that Alice has sent her public Diffie-Hellman key, Bob can complete
his part of the Diffie-Hellman protocol. Alice can't continue yet,
because she hasn't seen Bob's public key.

When we discussed Diffie-Hellman, we noted that it does not
*authenticate* the peer. Bob can compute a secret, but doesn't know he's
talking to Alice. As with TLS and other systems using Diffie-Hellman,
this problem is solved by authenticating the key exchange.

After verifying that Alice's public key is a valid value, Bob computes
the shared secret :math:`s = (g^y)^x`. Using a key derivation function,
he derives several keys from :math:`s`: two AES keys
:math:`c, c^\prime`, and four MAC keys
:math:`m_1, m_1^\prime, m_2, m_2^\prime`.

He chooses an identification number :math:`i_B` for his current
Diffie-Hellman key pair :math:`(x, g^x)`. This will be important once
Alice and Bob generate new key pairs, which they will do later on in the
OTR protocol.

Bob computes:

.. math::

   M_B = M_{m_1}(g^x, g^y, p_B, i_B)

.. math::

   X_B = (p_B, i_B, S(p_B, M_B))

He sends Alice :math:`r, E_c(X_B), M_{m_2}(E_c(X_B))`.

Signature Message
^^^^^^^^^^^^^^^^^

Alice can now confirm she's talking to Bob directly, because Bob signed
the authenticator for the exchange :math:`M_B` with his long-term DSA
key.

Alice can now also compute the shared secret: Bob has sent her
:math:`r`, which was previously used to encrypt Bob's Diffie-Hellman
public key. She then computes :math:`H(g^x)` herself, to compare it
against what Bob sent. By completing her side of the Diffie-Hellman
exchange (:math:`s = (g^x)^y`), she derives the same keys:
:math:`c, c^\prime, m_1, m_1^\prime, m_2, m_2^\prime`. Using :math:`m_2`, she
can verify :math:`M_{m_2}(E_c(X_B))`. Once that message is verified, she can
safely decrypt it using her computed :math:`c`.

She can then also compute :math:`M_B = M_{m_1}(g^x, g^y, p_B, i_B)`, and
verifies that it is the same as Bob sent. By verifying the signed
portion :math:`S(p_B, M_B)` against Bob's public key, she has now
unambiguously tied the current interaction to Bob's long-term
authentication key.

She then computes the same values Bob computed to tie his long-term key
to the short-term handshake, so that Bob can also authenticate her. She
chooses an identification number :math:`i_A` for her current DH keypair
:math:`(y, g^y)`, computes :math:`M_A = M_{m_1^\prime}(g^y, g^x, p_A, i_A)`
and :math:`X_A = p_A, i_A, S(p_A, M_A)`. Finally, she sends Bob
:math:`E_{c^\prime}(X_A), M_{m_2^\prime}(E_c(X_B))`.

Authenticating Alice
^^^^^^^^^^^^^^^^^^^^

Now Bob can also authenticate Alice, again by mirroring steps. First, he
verifies :math:`M_{m_2^\prime}(E_c(X_B))`. This allows him to check that
Alice saw the same :math:`X_B` he sent.

Once he decrypts :math:`E_{c^\prime}(X_A)`, he has access to
:math:`X_A`, which is Alice's long-term public key information. He can
then compute :math:`M_A = M_{m_1^\prime}(g^y, g^x, p_A, i_A)` to compare it with
the version Alice sent. Finally, he verifies :math:`S(p_A, M_A)` with Alice's
public key.


What have we accomplished?
^^^^^^^^^^^^^^^^^^^^^^^^^^

If all checks succeed then Alice and Bob have completed an authenticated
Diffie-Hellman exchange and have a shared secret that only the two of
them know.

Now that you've seen both sides of the authenticated handshake, you can
see why so many different keys are derived from the Diffie-Hellman
secret. Keys marked with a prime (:math:`\prime`) are for messages
originating from the second peer (the one responding to the
advertisement, in our case, Alice); keys without a prime are for the
initiating peer (in our case, Bob).

Data exchange
~~~~~~~~~~~~~

TODO: Explain (https://otr.cypherpunks.ca/Protocol-v3-4.0.0.html), #33


.. [28]
   For those too young to remember, Netscape is a company that used to
   make browsers.

.. [29]
   In case I haven't driven this point home yet: it only goes to show
   that designing cryptosystems is hard, and you probably shouldn't do
   it yourself.

.. [30]
   Compression Ratio Info-leak Made Easy

.. [31]
   Browser Reconnaissance and Exfiltration via Adaptive Compression of
   Hypertext

.. [32]
   Within limits; specifically within a sliding window, usually 32kB
   big. Otherwise, the pointers would grow bigger than the sequences
   they're meant to compress.

.. [33]
   An iframe is a web page embedded within a page.

.. [34]
   The key-value pairs in a URL after the question mark, e.g. the
   ``x=1&y=2`` in ``http://example.test/path?x=1&y=2``.

.. [35]
   They may be able to move more quickly than just one byte at a time,
   but this is the simplest way to reason about.

.. [36]
   GPG 2 also implements S/MIME, which is unrelated to the OpenPGP
   standard. This chapter only discusses OpenPGP.
