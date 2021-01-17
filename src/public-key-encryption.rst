Public-key encryption
---------------------

.. _description-4:

Description
~~~~~~~~~~~

So far, we have explored :term:`secret-key encryption`. Suppose that you 
have a cryptosystem that did not involve a single secret key. A cryptosystem that instead
has a key pair: one public key, which you freely distribute, and a
private one, which you keep to yourself.

People encrypt information intended for you by using your public
key. The information is impossible to decipher without your private
key. This is called :term:`public-key encryption`.

For a long time, people thought :term:`public-key encryption` was impossible. However, starting
in the 1970s, such algorithms began appearing. The first publicly
available encryption scheme was produced by three cryptographers from
MIT: Ron Rivest, Adi Shamir and Leonard Adleman. The algorithm they
published is still the most common one today, and carries the first
letters of their last names: RSA.

:term:`Public-key algorithm`\s are not limited to encryption. In fact, you
already saw a :term:`public-key algorithm` in this book that is not directly
used for encryption. Three related classes of
:term:`public-key algorithm`\s exist:

#. :term:`Key exchange <key exchange>` algorithms like Diffie-Hellman. They allow you to
   agree on a shared secret across an insecure medium.
#. Encryption algorithms, such as the ones we discuss in this
   chapter. They allow people to encrypt without agreement on a
   shared secret.
#. Signature algorithms, which we discuss in a later chapter. They
   allow you to sign any piece of information using your private key.
   Anyone else can easily verify using your public
   key.

Why not use public-key encryption for everything?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

At face value, it seems like :term:`public-key encryption` algorithms obsolete
all previous :term:`secret-key encryption` algorithms. We can use
public-key encryption for everything, avoiding the added complexity
in doing a :term:`key agreement` for symmetric algorithms. However,
practical cryptosystems are almost
always *hybrid* cryptosystems. While :term:`public-key algorithm`\s play a 
major role, the bulk of encryption and authentication is
completed by secret-key algorithms.

By far the most important reason is for performance. Compared to
our speedy :term:`stream cipher`\s (native or otherwise), :term:`public-key encryption`
mechanisms are extremely slow. RSA is limited to at most its key size,
which for 2048-bit means 256 bytes. Under these circumstances encryption
takes 0.29 megacycles, and decryption takes a whopping 11.12 megacycles.
:cite:`cryptopp:bench` To put this into perspective,
symmetric key algorithms work within an order of magnitude of 10 or so
cycles per byte in either direction. It takes a symmetric
key algorithm approximately 3 kilocycles to decrypt 256 bytes,
which is about 4000 times faster than the asymmetric version. The 
state-of-the-art technology in secure symmetric ciphers, AES-GCM, is even faster. AES-GCM with
hardware acceleration or Salsa20/ChaCha20 only needs about 2 to 4 cycles
per byte, which further widens the performance gap.

A few other problems occur with most practical cryptosystems. For
example, RSA cannot encrypt anything larger than its modulus. The modulus is
generally less than or equal 4096 bits, and far smaller than the largest
messages we would like to send. Still, the most important reason is the
speed argument given above.

RSA
~~~

As we already mentioned, RSA is one of the first practical
:term:`public-key encryption` schemes. It remains the most common one to this
day.

Encryption and decryption
^^^^^^^^^^^^^^^^^^^^^^^^^

RSA encryption and decryption relies on modular arithmetic. You may want
to review the :ref:`modular arithmetic primer <modular-arithmetic>`
before continuing.

This section describes the simplified math problem behind RSA, commonly
referred to as “textbook RSA”. By itself, this doesn't produce a secure
encryption scheme. We'll see a secure construction called OAEP that
builds on top of it in a later section.

In order to generate a key, you pick two large prime numbers :math:`p`
and :math:`q`. These numbers have to be picked at random, and in secret.
You multiply them together to produce the modulus :math:`N`, which is
public. Then, you pick an *encryption exponent* :math:`e`, which is also
public. Usually, this value is either 3 or 65537. Because those numbers
have a small number of ``1``'s in their binary expansion, you can
compute the exponentiation more efficiently. Put together,
:math:`(N, e)` is the public key. Anyone can use the public key to
encrypt a message :math:`M` into a ciphertext :math:`C`:

.. math::

   C \equiv M^e \pmod{N}

The next problem is decryption. It turns out that there is a value
:math:`d`, the *decryption exponent*, that can turn :math:`C` back into
:math:`M`. That value is fairly easy to compute assuming that you know
:math:`p` and :math:`q`, which we do. Using :math:`d`, you can decrypt
the message like so:

.. math::

   M \equiv C^d \pmod{N}

The security of RSA relies on that decryption operation being impossible
without knowing the secret exponent :math:`d`, and that the secret
exponent :math:`d` is very hard (practically impossible) to compute from
the public key :math:`(N, e)`. We'll see approaches for breaking RSA in
the next section.

Breaking RSA
^^^^^^^^^^^^

Like many cryptosystems, RSA relies on the presumed difficulty of a
particular mathematical problem. For RSA, this is the RSA problem,
specifically: to find the plaintext message :math:`M`, given a
ciphertext :math:`C`, and public key :math:`(N, e)` in the equation:

.. math::

   C \equiv M^e \pmod{N}

The easiest way we know how to do that is to factor :math:`N` back into
:math:`p \cdot q`. Given :math:`p` and :math:`q`, the attacker can just repeat
the process that the legitimate owner of the key does during key
generation in order to compute the private exponent :math:`d`.

Fortunately, we don't have an algorithm that can factor such large
numbers in reasonable time. Unfortunately, we also haven't proven it
doesn't exist. Even more unfortunate is that there is a theoretical
algorithm, called Shor's algorithm, that *would* be able to factor such
a number in reasonable time on a quantum computer. Right now, quantum
computers are far from practical, but it does appear that if someone in
the future manages to build one that's sufficiently large, RSA becomes
ineffective.

In this section, we have only considered a private key recovery attack
that attacks the purely abstract mathematical RSA problem by factoring
the modulus. In the next section, we will see all sorts of realistic
attacks on RSA that rely on flaws in the *implementation*, rather than
the mathematical problem stated above.

Implementation pitfalls
^^^^^^^^^^^^^^^^^^^^^^^

Right now, there are no known practical complete breaks against RSA.
That's not to say that systems employing RSA aren't routinely broken.
Like with most broken cryptosystems, there are plenty of cases where
sound components, improperly applied, result in a useless system. For a
more complete overview of the things that can go wrong with RSA
implementations, please refer to :cite:`boneh:twentyyears`
and :cite:`anderson:mindingyourpsandqs`. In this book, we'll
just highlight a few interesting ones.

PKCSv1.5 padding
''''''''''''''''

Salt
''''

Salt [#]_ is a provisioning system written in Python. It has one major
flaw: it has a module named ``crypt``. Instead of reusing existing
complete cryptosystems, it implements its own, using RSA and AES
provided by a third party package.

.. [#]
   So, there's Salt the provisioning system, :term:`salt`\s the things used in
   broken password stores, NaCl pronounced “salt” the cryptography
   library, and NaCl which runs native code in some browsers, and
   probably a bunch I'm forgetting. Can we stop naming things after it?

For a long time, Salt used a public exponent (:math:`e`) of 1, which
meant the encryption phase didn't actually do anything:
:math:`P^e \equiv P^1 \equiv P \pmod N`. This meant that the resulting ciphertext was in fact
just the plaintext. While this issue has now been fixed, this only goes
to show that you probably shouldn't implement your own cryptography.
Salt currently also supports SSH as a transport, but the aforementioned
DIY RSA/AES system remains, and is at time of writing still the
recommended and the default transport.

OAEP
^^^^

OAEP, short for optimal asymmetric encryption padding, is the state of
the art in RSA padding. It was introduced by Mihir Bellare and Phillip
Rogaway in 1995. :cite:`bellarerogaway:oaep`. Its structure
looks like this:

.. figure:: Illustrations/OAEP/Diagram.svg
   :align: center

The thing that eventually gets encrypted is :math:`X \| Y`, which is
:math:`n` bits long, where :math:`n` is the number of bits of :math:`N`,
the RSA modulus. It takes a random block :math:`R` that's :math:`k` bits
long, where :math:`k` is a constant specified by the standard. The
message is first padded with zeroes to be :math:`n - k` bits long. If
you look at the above “ladder”, everything on the left half is
:math:`n - k` bits long, and everything on the right half is :math:`k`
bits long. The random block :math:`R` and zero-padded message
:math:`M \| 000\ldots` are combined using two “trapdoor” functions, :math:`G` and
:math:`H`. A trapdoor function is a function that's very easy to compute
in one direction and very hard to reverse. In practice, these are
cryptographic hash functions; we'll see more about those later.

As you can tell from the diagram, :math:`G` takes :math:`k` bits and
turns them into :math:`n - k` bits, and :math:`H` is the other way
around, taking :math:`n - k` bits and turning them into :math:`k` bits.

The resulting blocks :math:`X` and :math:`Y` are concatenated, and the
result is encrypted using the standard RSA encryption primitive, to
produce the ciphertext.

To see how decryption works, we reverse all the steps. The recipient
gets :math:`X \| Y` when decrypting the message. They know :math:`k`,
since it is a fixed parameter of the protocol, so they can split up
:math:`X \| Y` into :math:`X` (the first :math:`n - k` bits) and
:math:`Y` (the final :math:`k` bits).

In the previous diagram, the directions are for padding being applied.
Reverse the arrows on the side of the ladder, and you can see how to
revert the padding:

TODO: reverse arrows

We want to get to :math:`M`, which is in :math:`M \| 000\ldots`. There's
only one way to compute that, which is:

.. math::

   M \| 000\ldots = X \xor G(R)

Computing :math:`G(R)` is a little harder:

.. math::

   G(R) = G(H(X) \xor Y)

As you can see, at least for some definitions of the functions :math:`H`
and :math:`G`, we need all of :math:`X` and all of :math:`Y` (and hence
the entire encrypted message) in order to learn anything about
:math:`M`. There are many functions that would be a good choice for
:math:`H` and :math:`G`; based on cryptographic hash functions, which
we'll discuss in more detail later in the book.

Elliptic curve cryptography
~~~~~~~~~~~~~~~~~~~~~~~~~~~

TODO: This

Remaining problem: unauthenticated encryption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Most :term:`public-key encryption` schemes can only encrypt small chunks of data
at a time, much smaller than the messages we want to be able to send.
They are also generally quite slow, much slower than their symmetric
counterparts. Therefore public-key cryptosystems are almost always used
in conjunction with secret-key cryptosystems.

When we discussed :term:`stream cipher`\s, one of the remaining issues that we
were facing was that we still had to exchange secret keys with a large
number of people. With public-key cryptosystems such as public
encryption and :term:`key exchange` protocols, we've now seen two ways that we
can solve that problem. That means that we can now communicate with
anyone, using only public information, completely secure from
eavesdroppers.

So far we've only been talking about encryption without any form of
authentication. That means that while we can encrypt and decrypt
messages, we cannot verify that the message is what the sender actually
sent.

While unauthenticated encryption may provide secrecy, we have already
seen that without authentication an active attacker can generally modify
valid encrypted messages successfully, despite the fact that they don't
necessarily know the corresponding plaintext. Accepting these messages
can often lead to secret information being leaked, meaning we don't even
get secrecy. The CBC padding attacks we've already discussed illustrate
this.

As a result it has become evident that we need ways to authenticate as
well as encrypt our secret communications. This is done by adding extra
information to the message that only the sender could have computed.
Just like encryption, authentication comes in both private-key
(symmetric) and public-key (asymmetric) forms. Symmetric authentication
schemes are typically called :term:`message authentication code`\s, while the
public-key equivalent is typically called a signature.

First, we will introduce a new cryptographic primitive: hash functions.
These can be used to produce both signature schemes as well as message
authentication schemes. Unfortunately, they are also very often abused
to produce entirely insecure systems.
