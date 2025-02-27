#include <stdio.h>
#include <string.h>
struct student
    {
        char name [50];
        int number;
        int age;
    };
void showStudentData(struct student *st){
        printf("\nStudent:\n");
        printf("Name: %s\n", st->name);
        printf("Number: %d\n", st->number);
        printf("Age: %d \n", st->age);
    };
int main(){
        struct student st1;
        struct student st2;

        strcpy(st1.name, "Krishna");
        st1.number = 5;
        st1.age = 21;

        strcpy(st2.name, "Torner");
        st2.number = 4;
        st2.age = 27;

        showStudentData(&st1);
        showStudentData(&st2);

        return 0;
    }