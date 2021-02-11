#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <string.h>

const int ENTRY_SIZE = 11;

off_t entries_list_size() {
    struct stat st;

    if (stat("/tmp/entries_list", &st) == 0) {
        return st.st_size;
    }

    return -1;
}

void seek_file(FILE* file, long mid) {
    fseek(file, mid * (ENTRY_SIZE + 1), SEEK_SET);
}

int entry_is_in_mid(FILE* file, char* entry, long mid) {
    char current_entry[ENTRY_SIZE + 1];
    strcpy(current_entry, "\0");

    seek_file(file, mid);

    fread(current_entry, ENTRY_SIZE, 1, file);
    current_entry[ENTRY_SIZE] = '\0';

    return strncmp(entry, current_entry, ENTRY_SIZE) == 0;
}

int entry_lt_value_in_mid(FILE* file, char* entry, long mid) {
    char current_entry[ENTRY_SIZE + 1];
    strcpy(current_entry, "\0");

    seek_file(file, mid);

    fread(current_entry, ENTRY_SIZE, 1, file);
    current_entry[ENTRY_SIZE] = '\0';

    return atoi(entry) < atoi(current_entry);
}

int find_entry(FILE* file, int last, int size, char* entry) {
    if (size >= last) {
        long mid = last + (size - last) / 2;

        if (entry_is_in_mid(file, entry, mid)) {
            return mid;
        }
        if (entry_lt_value_in_mid(file, entry, mid)) {
            return find_entry(file, last, mid - 1, entry);
        }
        return find_entry(file, mid + 1, size, entry);
    }
    return -1;
}

int search(char* entry) {
    FILE* file;
    int result = 0;

    file = fopen("/tmp/entries_list", "r");

    long number_of_entries = entries_list_size() / (ENTRY_SIZE + 1);
    result = find_entry(file, 0, number_of_entries, entry) >= 0;

    fclose(file);
    return result;
}
