import re
import sys
from ete3 import Tree, TreeStyle


def get_genome_metadata():
    """
    Get genome metadata from README.md.

    ## Meta data of genomes
    | Accession No.   | Database name   | Collection date | Country     | State/City    | Notes                                                                  |
    | --------------- | --------------- | --------------- | ----------- | ------------- | ---------------------------------------------------------------------- |
    | MT126808        | Genbank         | 28-Feb-2020     | Brazil      | Sao Paulo     | Traveler from Switzerland and Italy (Milan) to Brazil                  |
    | MT123291        | Genbank         | 29-Jan-2020     | China       | Guangzhou     |                                                                        |
    | MT123290        | Genbank         | 05-Feb-2020     | China       | Guangzhou     |                                                                        |
    :return:
    """
    f = open("README.md", "r")
    lines = f.readlines()
    is_meta_table = False
    metas = {}

    for line in lines:
        if line.startswith("## Meta data of genomes"):
            is_meta_table = True
            continue

        if is_meta_table and not line.startswith("|"):
            is_meta_table = False

        if is_meta_table and line.startswith("|"):
            (sep1, accession, db, date, country, state, notes, sep2) \
                = re.sub("\s{2,}", "", line) \
                .replace("| ", "|") \
                .replace(" |", "|") \
                .replace(":", "") \
                .replace("(", "") \
                .replace(")", "") \
                .split("|")

            # | MT126808 | Genbank | 28-Feb-2020 | Brazil | Sao Paulo | Traveler from Switzerland and Italy(Milan) to Brazil |
            # -> Brazil Sao Paulo 28-Feb-2020 MT126808
            metas[accession] = "{} {} {} {}".format(country, state, date, accession)

    f.close()

    return metas


def rename_accession_no(nwk_file):
    """
    Rename accession No. to genome metadata.
    :param nwk_file:
    :return:
    """
    metas = get_genome_metadata()

    f = open(nwk_file, "r")
    nwk = f.read()

    for d in metas:
        nwk = re.sub(d + "..", descriptions[d], nwk)

    return nwk


def create_tree(nwk_file, output_png):
    """
    Create tree image from a nwk file.
    :param nwk_file:
    :param output_png:
    :return:
    """
    nwk = rename_accession_no(nwk_file)
    t = Tree(nwk)
    ts = TreeStyle()
    ts.show_leaf_name = True
    ts.show_branch_length = True
    ts.show_branch_support = True
    t.render(output_png, dpi=150, units='mm', tree_style=ts)


if __name__ == '__main__':
    args = sys.argv
    if args.count != 3:
        print("Usage: python create_tree.py [nwk_file] [output_png]")
        sys.exit(1)

    nwk_file = args[1]
    output_png = args[2]

    create_tree(nwk_file, output_png)
