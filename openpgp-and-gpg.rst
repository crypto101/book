OpenPGP and GPG
---------------

.. _description-10:

Description
~~~~~~~~~~~

OpenPGP is an open standard that describes a method for encrypting and
signing messages. GPG is the most popular implementation of that
standard [#]_, available under a free software license.

.. [#]
   GPG 2 also implements S/MIME, which is unrelated to the OpenPGP
   standard. This chapter only discusses OpenPGP.

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
