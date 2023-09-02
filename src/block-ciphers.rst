Block ciphers
-------------

   Few false ideas have more firmly gripped the minds of so many intelligent men
   than the one that, if they just tried, they could invent a cipher that no one
   could break.

       *David Kahn*

.. _description-1:

Description
~~~~~~~~~~~

A :term:`block cipher` is an algorithm that encrypts blocks of a
fixed length. The encryption function :math:`E` transforms
plaintext blocks :math:`P` into ciphertext blocks :math:`C` by using a
secret key :math:`k`:

.. math::

   C = E(k, P)

Plaintext and ciphertext blocks are sequences of bits and always match in size. The 
block cipher's *block size* is a fixed size. :term:`Keyspace` is the set of all possible keys.

Once we encrypt plaintext blocks into ciphertext blocks, they are later
decrypted to recover original plaintext block. The original plaintext block
:math:`P` is produced using a decryption function :math:`D`. It takes the
ciphertext block :math:`C` and the key :math:`k` (same as the one used to
encrypt the block) as inputs.

.. math::

   P = D(k, C)

Or, visually represented in blocks:

.. figure:: Illustrations/BlockCipher/BlockCipher.svg
   :align: center

A block cipher is an example of a :term:`symmetric-key encryption` scheme, also
known as a :term:`secret-key encryption` scheme. The same secret
key is used for both encryption and decryption. Later in the book, we contrast this
with :term:`public-key encryption` algorithms, which have a distinct key for
encryption and decryption.

A block cipher is a *keyed permutation*. It is a *permutation* because 
the block cipher maps each possible block to another block. It is 
also a *keyed* permutation because the key determines exactly which 
blocks map to which. It is important for the block cipher to be a permutation because the
recipient must map blocks back to the original blocks.

We illustrate this by looking at a block cipher with an impractical,
tiny 4-bit block size. :math:`2^4 = 16` possible blocks. Since each
of the blocks map to a hexadecimal digit, we represent the blocks
by that digit. :numref:`fig-BlockCipherBlocks`
illustrates blocks that the cipher operates on.


.. _fig-BlockCipherBlocks:

.. figure:: Illustrations/BlockCipher/AllNodes.svg
   :align: center

   All 16 nodes operated on by the block cipher. Each node is designated by a hexadecimal digit.

Once we select a secret key, the block cipher uses it to determine
the encryption of any given block. We illustrate that
relationship with an arrow. The tail of the arrow has the block
encrypted with :math:`E` under key :math:`k` and the arrowhead is mapped to the block.

.. _fig-BlockCipherEncryption:

.. figure:: Illustrations/BlockCipher/Encryption.svg
   :align: center

   An encryption permutation made by a block cipher under a particular key :math:`k`.

In :numref:`fig-BlockCipherEncryption`, note
that the permutation is not just one big cycle. It contains a large cycle of
7 elements, and several smaller cycles of 4, 3 and 2 elements each. It is
also perfectly possible that an element encrypts to itself. This is to
be expected when selecting random permutations, which is approximately
what a block cipher is doing; it doesn't demonstrate a bug in the block
cipher.

When you decrypt instead of encrypt, the block cipher 
computes the inverse permutation. In :numref:`fig-BlockCipherDecryption`,
we get the same illustration. The difference between the illustrations is that all arrowheads point
in the opposite direction.

.. _fig-BlockCipherDecryption:

.. figure:: Illustrations/BlockCipher/Decryption.svg
   :align: center

   The decryption permutation produced by the block cipher under the same key
   :math:`k`. It is the inverse of the encryption permutation in that all arrowheads
   reverse.


The key defines which blocks map to which blocks. 
A different key would lead to a different set of
arrows, as you can see in :numref:`fig-BlockCipherEncryptionDifferentKey`.

.. _fig-BlockCipherEncryptionDifferentKey:

.. figure:: Illustrations/BlockCipher/Encryption2.svg
   :align: center

   An encryption permutation produced by the block cipher under a different key.

In this illustration, you'll even notice that there are two permutations
of length 1: an element that maps to itself. This is again something to
be expected when selecting random permutations.

Knowing a bunch of (input, output) pairs for a given key shouldn't give
you any information about any other (input, output) pairs under that
key [#]_. As long as we're talking about a hypothetical perfect block
cipher, there's no easier way to decrypt a block other than to
“brute-force” the key: i.e. just try every single one of them until you
find the right one.

.. [#]
   The attentive reader may have noticed that this breaks in the
   extremes: if you know all but one of the pairs, then you know the
   last one by exclusion.

Our toy illustration block cipher only has 4 bit blocks, or
:math:`2^4 = 16` possibilities. Real, modern block ciphers have much
larger block sizes, such as 128 bits, or :math:`2^{128}` (slightly more
than :math:`10^{38.5}`) possible blocks. Mathematics tells us that there
are :math:`n!` (pronounced “:math:`n` factorial”) different permutations
of an :math:`n` element set. It's defined as the product of all of the
numbers from 1 up to and including :math:`n`:

.. math::

   n! = 1 \cdot 2 \cdot 3 \cdot \ldots \cdot (n - 1) \cdot n

Factorials grow incredibly quickly. For example, :math:`5! = 120`,
:math:`10! = 3628800`, and the rate continues to increase. The number of permutations
of the set of blocks of a cipher with a 128 bit block size is
:math:`(2^{128})!`. Just :math:`2^{128}` is large already (it takes 39
digits to write it down), so :math:`(2^{128})!` is a mind-bogglingly
huge number, impossible to comprehend. Common key sizes are only in the
range of 128 to 256 bits, so there are only between :math:`2^{128}` and
:math:`2^{256}` permutations a cipher can perform. That's just a tiny
fraction of all possible permutations of the blocks, but that's okay:
that tiny fraction is still nowhere near small enough for an attacker to
just try them all.

Of course, a block cipher should be as easy to compute as possible, as
long as it doesn't sacrifice any of the above properties.

AES
~~~

The most common block cipher in current use is AES.

Contrary to its predecessor DES (which we'll look at in more detail in
the next chapter), AES was selected through a public, peer-reviewed
competition following an open call for proposals. This competition
involved several rounds where all of the contestants were presented,
subject to extensive cryptanalysis, and voted upon. The AES process was
well-received among cryptographers, and similar processes are generally
considered to be the preferred way to select cryptographic standards.

Prior to being chosen as the Advanced Encryption Standard, the algorithm
was known as Rijndael, a name derived from the two last names of the
Belgian cryptographers that designed it: Vincent Rijmen and Joan Daemen.
The Rijndael algorithm defined a family of block ciphers, with block
sizes and key sizes that could be any multiple of 32 bits between 128
bits and 256 bits. :cite:`daemen:aes` When Rijndael became
AES through the FIPS standardization process, the parameters were
restricted to a block size of 128 bits and keys sizes of 128, 192 and
256 bits. :cite:`fips:aes`

There are no practical attacks known against AES. While there have been
some developments in the last few years, most of them involve
related-key attacks :cite:`cryptoeprint:2009:317`, some of
them only on reduced-round versions of AES
:cite:`cryptoeprint:2009:374`.  [#]_

.. [#]
   Symmetric algorithms usually rely on a round function to be repeated
   a number of times. Typically each invocation involves a “round key”
   derived from the main key. A reduced-round version is intentionally
   easier to attack. These attacks can give insight as to how resistant
   the full cipher is.

   A related key attack involves making some predictions about how AES
   will behave under several different keys with some specific
   mathematical relation. These relations are fairly simple, such as
   XORing with an attacker-chosen constant. If an attacker is allowed to
   encrypt and decrypt a large number of blocks with these related keys,
   they can attempt to recover the original key with significantly less
   computation than would ordinarily be necessary to crack it.

   While a theoretically ideal block cipher wouldn't be vulnerable to a
   related key attack, these attacks aren't considered practical
   concerns. In practice cryptographic keys are generated via a
   cryptographically secure pseudorandom number generator, or a
   similarly secure :term:`key agreement` scheme or key derivation scheme (we'll
   see more about those later). Therefore, the odds of selecting two
   such related keys by accident is nonexistent. These attacks are
   interesting from an academic perspective: they can help provide
   insight in the workings of the cipher, guiding cryptographers in
   designing future ciphers and attacks against current ciphers.

A closer look at Rijndael
^^^^^^^^^^^^^^^^^^^^^^^^^

.. canned_admonition::
   :from_template: advanced

AES includes several independent steps. At a high level, AES is a
:term:`substitution-permutation network`.

Key schedule
''''''''''''

The next steps show how AES requires separate keys for each round. In the key
schedule process, AES derives 128-bit keys for each
round from one master key.

First, the key separates into 4 byte columns. The key rotates and
each byte runs through an S-box (substitution box), which maps it
to something else. Each column is then XORed with a round constant. The
last step is to XOR the result with the previous round key.

The next columns are XORed with the previous round key to produce
the remaining columns.

SubBytes
''''''''

The AES SubBytes step applies to the S-box (substitution box).
The S-box substitutes a byte with another byte, and the S-box is
applied to each byte in the AES state.

The SubBytes formula takes the multiplicative inverse over the Galois field. An
affine transformation applies so that there are no values
:math:`x`, additionally :math:`x \xor S(x) = 0` or :math:`x \xor S(x)=\texttt{0xff}`.
To rephrase, there are no values of :math:`x` that the substitution box maps to
:math:`x` itself, nor to :math:`x` with all bits flipped. This creates a cipher
resistant to linear cryptanalysis. It is unlike the earlier DES algorithm with
a fifth S-box that caused serious security problems.  [#]_

.. figure:: Illustrations/AES/SubBytes.svg
   :align: center

.. [#]
   In its defense, linear attacks were publicly unknown back when DES
   was designed.

ShiftRows
'''''''''

After applying the SubBytes step to the 16 bytes of the block, AES
shifts the rows in a :math:`4 \times 4` array:

.. figure:: Illustrations/AES/ShiftRows.svg
   :align: center

MixColumns
''''''''''

MixColumns multiplies each column of the state with a fixed polynomial.

ShiftRows and MixColumns represent the diffusion properties of AES.

.. figure:: Illustrations/AES/MixColumns.svg
   :align: center

AddRoundKey
'''''''''''

As the name implies, the AddRoundKey step adds bytes from the round
key to the state of the cipher.

.. figure:: Illustrations/AES/AddRoundKey.svg
   :align: center

DES and 3DES
~~~~~~~~~~~~

The DES is among the oldest block ciphers that saw widespread use. DES
was published as an official FIPS standard in 1977. It is no longer
considered secure, mainly due to its tiny key size of 56 bits. (The DES
algorithm takes a 64 bit key input, but the remaining 8 bits
are only used for parity checking, and are immediately discarded. DES
should not be used in new systems. On modern hardware, DES can be brute
forced in less than a day. :cite:`sciengines:breakdes`

In efforts to extend the DES algorithm life in that
the spent hardware development can be reused,
people created 3DES. It is a scheme where input is first encrypted, then
decrypted, then encrypted again:

.. math::

   C = E_{DES}(k_1, D_{DES}(k_2, E_{DES}(k_3, p)))

The scheme provides two key improvements:

-  Applying the algorithm three times makes the cipher harder to
   attack directly through cryptanalysis.
-  The option of using more total key bits spread over
   the three keys introduces a larger set of all possible keys, and
   brute-force becomes impractical.

The three keys can be chosen independently (yielding 168 key
bits), or :math:`k_3 = k_1` (yielding 112 key bits), or
:math:`k_1 = k_2 = k_3`, which, of course, is just plain old DES (with
56 key bits). In the last keying option, the middle decryption reverses
the first encryption. You really only get the effect of the last
encryption. It is intended as a backwards compatibility mode for
existing DES systems. If 3DES had been defined as
:math:`E(k_1, E(k_2, E(k_3, p)))`, it would have been impossible to use
3DES implementations for systems that require DES compatibility.
This is particularly important for hardware implementations because 
providing a secondary, regular “single DES”
interface next to the primary 3DES interface is not always possible.

Some attacks on 3DES are known, which reduces their effective security. While
breaking 3DES with the first keying option is currently impractical,
3DES is a poor choice for a modern cryptosystem. The security margin
is small and continues to shrink as cryptographic attacks
improve and processing power grows.

Far better alternatives, such as AES, are available. AES are
more secure than 3DES and much faster. On the
same hardware and :term:`mode of operation` (we will explain what that
means in the next chapter), AES-128 only takes 12.6 cycles per byte
while 3DES takes up to 134.5 cycles per byte.
:cite:`cryptopp:bench` Despite being risker from a security
perspective, 3DES are literally an order of magnitude slower.

While more DES iterations can increase the security margin, they
are not used in practice for a few reasons. First off, the process is not
standardized beyond three iterations. Also, the performance becomes
worse as you add more iterations. Finally, increasing the key bits has
diminishing security returns. The security level slightly increases as the number 
of key bits increases. While 3DES with keying option 1 has a key length of 168 bits,
the effective security level is estimated to be only 112 bits.

Although 3DES is significantly worse in terms of performance and
slightly worse in terms of security, 3DES is the workhorse of the
financial industry today. It is likely used for many years to come because
of the plethora of already existing standards 
and new ones created. Additionally, the industry is 
technologically conservative considering that Fortran and Cobol continue
reigning supreme on massive mainframes. No major change is expected 
unless there are large cryptanalytic
breakthroughs threatening the security of 3DES.

.. _remaining-problems-1:

Remaining problems
~~~~~~~~~~~~~~~~~~

Even with block ciphers, unsolved problems linger.

For example, we can only send very limited length messages: the
block length of the block cipher. Obviously, we would like to 
send much larger messages, or, ideally, streams of indeterminate size.
We will address this problem with a :ref:`stream cipher <stream-ciphers>`.

We reduced the key size drastically as in the total size of all data ever sent under a 
one-time pad scheme versus a few bytes for most block ciphers. Further work 
involves addressing the issue and aligning on those few key bytes, potentially over an insecure channel.  
We will address this problem in a later chapter with a :ref:`key exchange protocol <key-exchange>`.
