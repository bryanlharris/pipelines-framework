"""
Write one-page PDFs full of fake PII, for testing the PDF PII inventory.

Each PDF gets a random mix of PII types; about one in five gets none, as a
clean control. Open a PDF to see what it holds. Every value is fake and safe
to publish:
  SSN 9xx-xx-xxxx      never issued (no SSN starts with 9)
  phone 555-01xx       reserved for fiction
  IP 192.0.2.x         reserved for documentation (RFC 5737)
  email @example.com   reserved for documentation (RFC 2606)
  cards                the standard card-network test numbers

No libraries needed: the PDF is written by hand (one page, Helvetica).

Usage: py datasets/documents/make_fake_pdf.py [-n N] <out_dir>
Writes documents_fake_001.pdf ... into out_dir (N defaults to 1).
upload_documents.ps1 runs this, uploads the PDFs, and deletes them.
"""
import argparse
import random
from datetime import datetime
from pathlib import Path

# Plain lines with no PII: they pad every document, and are all a clean one has.
FILLER = [
    'Orientation is scheduled for the first Monday of next month.',
    'Badge photos are taken at the front desk.',
    'Parking permits are issued for lot B.',
    'The quarterly review moved to the second floor conference room.',
    'Please return laptops to IT before your last day.',
    'Lunch is provided on training days.',
    'Questions go to the help desk, extension 4100.',
    'Building hours are 7 a.m. to 7 p.m., Monday to Friday.',
]

TITLES = ['Employee Record', 'Payroll Update', 'Visitor Log', 'IT Access Request',
          'Vendor Form', 'Travel Expense Report', 'Benefits Enrollment', 'Meeting Notes']

FIRST = ['Jane', 'John', 'Alex', 'Maria', 'Sam', 'Priya', 'Chen', 'Omar']
LAST  = ['Sample', 'Example', 'Placeholder', 'Testcase', 'Demo', 'Fakename']
CARDS = ['4111 1111 1111 1111', '5555 5555 5555 4444', '3782 822463 10005']


def fake_lines(rng):
    """One line of fake PII per type. Each type makes its own fresh value."""
    first, last = rng.choice(FIRST), rng.choice(LAST)
    return {
        'person_name':    f'Name: {first} {rng.choice("ABCDEFGH")}. {last}',
        'ssn':            f'Social Security Number: 9{rng.randint(0, 99):02d}-{rng.randint(1, 99):02d}-{rng.randint(1, 9999):04d}',
        'date_of_birth':  f'Date of Birth: {rng.randint(1, 12):02d}/{rng.randint(1, 28):02d}/{rng.randint(1950, 2005)}',
        'driver_license': f'Driver License: S{rng.randint(0, 999):03d}-{rng.randint(0, 9999):04d}-{rng.randint(0, 9999):04d}',
        'phone_number':   f'Phone: (202) 555-01{rng.randint(0, 99):02d}',
        'email_address':  f'Email: {first.lower()}.{last.lower()}@example.com',
        'bank_account':   f'Bank account: {rng.randint(10**11, 10**12 - 1)}, routing 011000015',
        'credit_card':    f'Card: {rng.choice(CARDS)}, exp {rng.randint(1, 12):02d}/{rng.randint(27, 32)}',
        'ip_address':     f'Workstation IP: 192.0.2.{rng.randint(1, 254)}',
    }


def document_lines(rng):
    """The lines of one document: some PII (or none), mixed with filler."""
    pii = fake_lines(rng)
    if rng.random() < 0.2:
        chosen = []
    else:
        chosen = [pii[label] for label in rng.sample(sorted(pii), rng.randint(1, 5))]
    lines = chosen + rng.sample(FILLER, 3)
    rng.shuffle(lines)
    return lines


def escape(text):
    """Escape the characters PDF strings treat as special."""
    return text.replace('\\', '\\\\').replace('(', '\\(').replace(')', '\\)')


def page_content(title, lines):
    """The drawing commands for the page: a title, then one line per row."""
    commands = ['BT', '/F1 18 Tf', '72 720 Td', f'({escape(title)}) Tj',
                '/F1 11 Tf', '0 -32 Td', '16 TL']
    for line in lines:
        commands.append(f'({escape(line)}) Tj T*')
    commands.append('ET')
    return '\n'.join(commands).encode('latin-1')


def build_pdf(title, lines):
    """A minimal valid PDF: catalog, page tree, one page, font, content."""
    content = page_content(title, lines)
    objects = [
        b'<< /Type /Catalog /Pages 2 0 R >>',
        b'<< /Type /Pages /Kids [3 0 R] /Count 1 >>',
        b'<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] '
        b'/Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >>',
        b'<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>',
        b'<< /Length ' + str(len(content)).encode() + b' >>\nstream\n'
        + content + b'\nendstream',
    ]

    pdf = bytearray(b'%PDF-1.4\n')
    offsets = []
    for number, body in enumerate(objects, start=1):
        offsets.append(len(pdf))
        pdf += f'{number} 0 obj\n'.encode() + body + b'\nendobj\n'

    xref_start = len(pdf)
    pdf += f'xref\n0 {len(objects) + 1}\n'.encode()
    pdf += b'0000000000 65535 f \n'
    for offset in offsets:
        pdf += f'{offset:010d} 00000 n \n'.encode()
    pdf += (f'trailer\n<< /Size {len(objects) + 1} /Root 1 0 R >>\n'
            f'startxref\n{xref_start}\n%%EOF\n').encode()
    return bytes(pdf)


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('out_dir', help='folder to write the PDFs into')
    parser.add_argument('-n', type=int, default=1, help='how many PDFs (default 1)')
    args = parser.parse_args()

    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    rng = random.Random()
    for number in range(1, args.n + 1):
        title = f'{rng.choice(TITLES)} - {datetime.now():%Y-%m-%d}'
        path = out_dir / f'documents_fake_{number:03d}.pdf'
        path.write_bytes(build_pdf(title, document_lines(rng)))
        print(f'Wrote {path}')


if __name__ == '__main__':
    main()
