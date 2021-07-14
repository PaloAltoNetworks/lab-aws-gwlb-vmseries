from panos import panorama
import os
username = os.environ["panorama_username"]
passw = os.environ["panorama_password"]
hostname = os.environ["panorama_host"]
student_id = os.environ["panorama_student_id"]
# destroy = True
# create = False
pano = panorama.Panorama(hostname=hostname, api_password=passw, api_username=username)
def build_access_domain():
    access_domain_xp = "/config/mgt-config/access-domain/entry[@name='ACD-STUDENT-{}']".format(student_id)
    access_domain_e = "<device-groups><member>DG-STUDENT-{}</member></device-groups><templates>" \
                      "<member>TPL-COMMON</member><member>TPL-STUDENT-BASE-{}</member>" \
                      "<member>TPL-STUDENT-STACK-{}</member></templates>" \
                      "<shared-access>write</shared-access>".format(student_id, student_id, student_id)
    pano.xapi.set(xpath=access_domain_xp, element=access_domain_e)
def build_admin_user():
    admin_password = pano.xapi.op('request password-hash password "{}"'.format("student-" + student_id), cmd_xml=True)
    r = admin_password
    phash = r.find(".//phash").text
    admin_add_xp = "/config/mgt-config/users/entry[@name='student-{}']".format(student_id)
    admin_add_e = '<permissions><role-based><custom><dg-template-profiles><entry name="ACD-STUDENT-{}">' \
                  '<profile>PASUMMIT-RBAC-ROLE</profile></entry></dg-template-profiles></custom></role-based>' \
                  '</permissions><phash>{}</phash>'.format(student_id, phash)
    pano.xapi.set(xpath=admin_add_xp, element=admin_add_e)

    # Build Admin user on local template
    template_admin_add_xp = "/config/devices/entry[@name='localhost.localdomain']/template/entry[@name='TPL-STUDENT-BASE-{}']/config/mgt-config/users/entry[@name='student-{}']".format(student_id, student_id)
    template_admin_add_e = '<permissions><role-based><superuser>yes</superuser></role-based></permissions><phash>{}</phash>'.format(phash)

    pano.xapi.set(xpath=template_admin_add_xp, element=template_admin_add_e)

def do_commit():
    try:
        result = pano.commit_all(sync_all=True, exception=True, sync=True,
                                 devicegroup="DG-STUDENT-{}".format(student_id))
        return result
    except:
        return False
def panorama_commit():
    try:
        commit_cmd = panorama.PanoramaCommit()
        #commit_cmd = panorama.PanoramaCommit(device_groups=[f"DG-STUDENT-{student_id}"], templates=[f"TPL-STUDENT-BASE-{student_id}"], template_stacks=[f"TPL-STUDENT-STACK-{student_id}"])
        result = pano.commit(cmd=commit_cmd, sync=True, exception=True)
        return result
    except:
        return False
def main():
    # if create == "True":
    # if destroy == "True":
    #     pano.xapi.delete(xpath=access_domain_xp)
    #     pano.xapi.delete(xpath=admin_add_xp)
    build_access_domain()
    build_admin_user()
    while True:
        try:
            completion = panorama_commit()
            jobid = completion['jobid']
            response = completion['success']
            account = completion['user']
            warnings = completion['warnings']
            starttime = completion['starttime']
            firewalls = completion['devices']
            print(jobid, response, account)
            break
        except Exception as e:
            print(f"Commit Failed, please check Panorama. Message: {e}")
if __name__ == "__main__":
    main()