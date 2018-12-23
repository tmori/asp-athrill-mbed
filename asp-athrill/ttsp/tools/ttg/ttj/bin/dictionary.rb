#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Digital Craft Inc.
#
#  �嵭����Ԥϡ��ʲ���(1)��(4)�ξ������������˸¤ꡤ�ܥ��եȥ���
#  �����ܥ��եȥ���������Ѥ�����Τ�ޤࡥ�ʲ�Ʊ���ˤ���ѡ�ʣ������
#  �ѡ������ۡʰʲ������ѤȸƤ֡ˤ��뤳�Ȥ�̵���ǵ������롥
#  (1) �ܥ��եȥ������򥽡��������ɤη������Ѥ�����ˤϡ��嵭������
#      ��ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ��꤬�����Τޤޤη��ǥ���
#      ����������˴ޤޤ�Ƥ��뤳�ȡ�
#  (2) �ܥ��եȥ������򡤥饤�֥������ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ�����Ǻ����ۤ�����ˤϡ������ۤ�ȼ���ɥ�����ȡ�����
#      �ԥޥ˥奢��ʤɡˤˡ��嵭�����ɽ�����������Ѿ�浪��Ӳ���
#      ��̵�ݾڵ����Ǻܤ��뤳�ȡ�
#  (3) �ܥ��եȥ������򡤵�����Ȥ߹���ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ��ʤ����Ǻ����ۤ�����ˤϡ����Τ����줫�ξ�����������
#      �ȡ�
#    (a) �����ۤ�ȼ���ɥ�����ȡ����Ѽԥޥ˥奢��ʤɡˤˡ��嵭����
#        �ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ����Ǻܤ��뤳�ȡ�
#    (b) �����ۤη��֤��̤�������ˡ�ˤ�äơ�TOPPERS�ץ������Ȥ�
#        ��𤹤뤳�ȡ�
#  (4) �ܥ��եȥ����������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������뤤���ʤ�»
#      ������⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ����դ��뤳�ȡ�
#      �ޤ����ܥ��եȥ������Υ桼���ޤ��ϥ���ɥ桼������Τ����ʤ���
#      ͳ�˴�Ť����ᤫ��⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ�
#      ���դ��뤳�ȡ�
#
#  �ܥ��եȥ������ϡ�̵�ݾڤ��󶡤���Ƥ����ΤǤ��롥�嵭����Ԥ�
#  ���TOPPERS�ץ������Ȥϡ��ܥ��եȥ������˴ؤ��ơ�����λ�����Ū
#  ���Ф���Ŭ������ޤ�ơ������ʤ��ݾڤ�Ԥ�ʤ����ޤ����ܥ��եȥ���
#  �������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������������ʤ�»���˴ؤ��Ƥ⡤��
#  ����Ǥ�����ʤ���
#
#  $Id: dictionary.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "common/bin/CommonModule.rb"

#=====================================================================
# TTJModule
#=====================================================================
module TTJModule
  include CommonModule

  #===================================================================
  # Variation
  #===================================================================
  GRP_TTJ_VARIATION = {
    TSR_PRM_GAIN_TIME       => "����ư��",
    TSR_PRM_TIMER_ARCH      => "�����ޡ��������ƥ�����",
    TSR_PRM_ENA_EXC_LOCK    => "CPU��å����CPU�㳰ȯ��",
    TSR_PRM_IRC_ARCH        => "IRC�������ƥ�����",
    TSR_PRM_GCOV_ALL        => "GCOV����",
    TSR_PRM_SUPPORT_GET_UTM => "API��get_utm",
    TSR_PRM_SUPPORT_ENA_INT => "API��ena_int",
    TSR_PRM_SUPPORT_DIS_INT => "API��dis_int"
  }

  #===================================================================
  # Condition
  #===================================================================
  GRP_TTJ_CONDITION = {
    TSR_LBL_VARIATION => "�Хꥨ�������",
    TSR_LBL_PRE       => "������",
    TSR_LBL_DO        => "����",
    TSR_LBL_POST      => "�����"
  }

  #===================================================================
  # Object
  #===================================================================
  GRP_TTJ_OBJECT = [
    {TSR_OBJ_INIRTN      => "������롼����"        },
    {TSR_OBJ_TERRTN      => "��λ�롼����"          },

    {TSR_OBJ_ALARM       => "���顼��ϥ�ɥ�"      },
    {TSR_OBJ_CYCLE       => "�����ϥ�ɥ�"          },
    {TSR_OBJ_TASK        => "������"                },
    {TSR_OBJ_TASK_EXC    => "�������㳰�����롼����"},

    {TSR_OBJ_EXCEPTION   => "CPU�㳰�ϥ�ɥ�"       },
    {TSR_OBJ_INTHDR      => "����ߥϥ�ɥ�"        },
    {TSR_OBJ_ISR         => "����ߥ����ӥ��롼����"},

    {TSR_OBJ_SEMAPHORE   => "���ޥե�"              },
    {TSR_OBJ_EVENTFLAG   => "���٥�ȥե饰"        },
    {TSR_OBJ_DATAQUEUE   => "�ǡ������塼"          },
    {TSR_OBJ_P_DATAQUEUE => "ͥ���٥ǡ������塼"    },
    {TSR_OBJ_MAILBOX     => "�᡼��ܥå���"        },
    {TSR_OBJ_MEMORYPOOL  => "����Ĺ����ס���"    },
    {TSR_OBJ_SPINLOCK    => "���ԥ��å�"          },

    {TSR_OBJ_CPU_STATE   => "CPU����"               }
  ]

  #===================================================================
  # Attribute
  #===================================================================
  GRP_TTJ_ATTRIBUTE = [
    # TTJ��ID����
    {TTJ_STT_ID       => TTJ_STT_ID                    },
    
    # ����ñ��
    {TSR_PRM_TYPE     => "������"                      },
    {TSR_PRM_ATR      => "°��"                        },
    {TSR_PRM_EXINF    => "��ĥ����"                    },

    {TSR_PRM_STATE    => "����"                        },
    {TSR_PRM_SPNSTAT  => "����"                        },

    {TSR_PRM_HDLSTAT  => "�¹Ծ���"                    },
    {TSR_PRM_WOBJID   => "�Ԥ��װ�"                    },
    {TSR_PRM_LEFTTMO  => "�����ॢ������"              },

    {TSR_PRM_ITSKPRI  => "���ͥ����"                  },
    {TSR_PRM_TSKPRI   => "ͥ����"                      },

    {TSR_PRM_ACTCNT   => "��ư�׵ᥭ�塼����"        },
    {TSR_PRM_WUPCNT   => "�����׵ᥭ�塼����"        },
    {TSR_PRM_PORDER   => "ͥ����"                    },
    {TSR_PRM_ACTPRC   => "����ư�����դ��ץ��å�"  },
    {TSR_PRM_BOOTCNT  => "��ư���"                    },
    {TSR_PRM_PRCID    => "���դ��ץ��å�"            },
    {TSR_PRM_VAR      => "�ѿ�"                        },

    {TSR_PRM_CYCATR   => "°��"                        },
    {TSR_PRM_CYCTIM   => "����"                        },
    {TSR_PRM_CYCPHS   => "����"                        },

    {TSR_PRM_TASK     => "�оݥ�����ID"                },
    {TSR_PRM_TEXPTN   => "�������㳰�װ�"              },
    {TSR_PRM_PNDPTN   => "��α�㳰�װ�"                },

    # Ʊ�����̿����֥�������
    {TSR_PRM_MAXSEM   => "����񸻿�"                  },
    {TSR_PRM_ISEMCNT  => "����񸻿�"                  },
    {TSR_PRM_SEMCNT   => "���߻񸻿�"                  },

    {TSR_PRM_IFLGPTN  => "����ӥåȥѥ�����"          },
    {TSR_PRM_FLGPTN   => "���ߥӥåȥѥ�����"          },

    {TSR_PRM_DATACNT  => "��Ǽ�Ǥ���ǡ�����"          },
    {TSR_PRM_MAXDPRI  => "�ǡ���ͥ���٤κ�����"        },

    {TSR_PRM_MAXMPRI  => "��å�����ͥ���٤κ�����"    },
    {TSR_PRM_MSGLIST  => "�����Ԥ���å������Υꥹ��"  },

    {TSR_PRM_BLKCNT   => "�����Ǥ���֥�å��ν����"  },
    {TSR_PRM_FBLKCNT  => "�����Ǥ���֥�å��θ��߿�"  },
    {TSR_PRM_BLKSZ    => "�֥�å��Υ�����"            },
    {TSR_PRM_MPF      => "����Ĺ����ס������Ƭ����"},

    {TSR_PRM_WTSKLIST => "�Ԥ��������Υꥹ��"          },
    {TSR_PRM_STSKLIST => "�����Ԥ��������Υꥹ��"      },
    {TSR_PRM_RTSKLIST => "�����Ԥ��������Υꥹ��"      },
    {TSR_PRM_DATALIST => "�����ΰ�Υǡ����Υꥹ��"    },

    {TSR_PRM_LOCCPU   => "CPU��å�"                   },
    {TSR_PRM_DISDSP   => "�ǥ����ѥå��ػ�"            },
    {TSR_PRM_CHGIPM   => "�����ͥ���٥ޥ���"          },

    {TSR_PRM_SPINID   => "�����׵᥹�ԥ��å�"        },
    {TSR_PRM_PROCID   => "������"                      },

    {TSR_PRM_EXCNO    => "�㳰�ֹ�"                    },

    {TSR_PRM_INTNO    => "������ֹ�"                  },
    {TSR_PRM_INHNO    => "����ߥϥ�ɥ��ֹ�"          },
    {TSR_PRM_INTPRI   => "�����ͥ����"                },

    {TSR_PRM_ISRPRI   => "����ߥ����ӥ��롼����ͥ����"},

    {TSR_PRM_DO       => "����"                        },
    {TSR_PRM_GLOBAL   => "�����Х�"                  },

    {TSR_PRM_CLASS    => "��°���饹"                  }
  ]

  #===================================================================
  # Status
  #===================================================================
  GRP_TTJ_STATUS = {
    # ���֥������Ȥξ���
    KER_TTS_RUN       => "�¹�",
    KER_TTS_RDY       => "�¹Բ�ǽ",
    KER_TTS_WAI       => "�Ԥ�",
    KER_TTS_SUS       => "�����Ԥ�",
    KER_TTS_WAS       => "����Ԥ�",
    KER_TTS_RUS       => "�����Ԥ�[�¹Է�³��]",
    KER_TTS_DMT       => "�ٻ�",
    TSR_STT_R_WAITSPN => "���ԥ��å������Ԥ�[�¹Է�³��]",
    TSR_STT_A_WAITSPN => "���ԥ��å������Ԥ�[�¹Է�³��]",

    TSR_PRM_STATE => {
      TSR_OBJ_TASK     => "����",
      TSR_OBJ_ALARM    => "ư�����",
      TSR_OBJ_CYCLE    => "ư�����",
      TSR_OBJ_TASK_EXC => "�������㳰�ػߥե饰����",
      TSR_OBJ_INTHDR   => "����߶ػߥե饰����",
      TSR_OBJ_ISR      => "����߶ػߥե饰����"
    },

    # ����
    TSR_STT_TALM_STA  => "��ư��",
    TSR_STT_TALM_STP  => "�����",
    TSR_STT_TCYC_STA  => "��ư��",
    TSR_STT_TCYC_STP  => "�����",
    TSR_STT_TTEX_ENA  => "���ľ���",
    TSR_STT_TTEX_DIS  => "�ػ߾���",
    TSR_STT_TA_ENAINT => "���ꥢ",
    TSR_STT_TA_DISINT => "���å�",
    TSR_STT_ACTIVATE  => "�¹���",
    TSR_STT_STP       => "�����",
    TSR_STT_SLEEP     => "�����Ԥ�",
    TSR_STT_DELAY     => "���ַв��Ԥ�",

    # °��
    TSR_PRM_ATR => {
      KER_TA_NULL   => "���֥�������°������ꤷ�ʤ���",
      KER_TA_TPRI   => "���������Ԥ�����򥿥�����ͥ���ٽ�ˤ��롥",
      KER_TA_WMUL   => "ʣ�����������ԤĤΤ������",
      KER_TA_CLR    => "���������Ԥ�������˥��٥�ȥե饰�򥯥ꥢ���롥",
      KER_TA_MPRI   => "��å��������塼���å�������ͥ���ٽ�ˤ��롥",
      KER_TA_STA    => "�����ϥ�ɥ���������˼����ϥ�ɥ��ư��Ϥ��롥",
      KER_TA_ENAINT => "������׵�ػߥե饰�򥯥ꥢ���롥",
      KER_TA_DISINT => "������׵�ػߥե饰�򥻥åȤ��롥"
    },

    TSR_PRM_SYSCALL => "�����ƥॳ����",
    TSR_PRM_BOOL    => "�����ͥ���ư�����",

    # true�ζ���
    TSR_STT_TRUE => {
      TSR_PRM_LOCCPU          => "��å�����",
      TSR_PRM_DISDSP          => "�ػ߾���",
      TSR_PRM_GAIN_TIME       => "���ֿʹ�",
      TSR_PRM_ENA_EXC_LOCK    => "CPU��å����CPU�㳰ȯ�������",
      TSR_PRM_DO              => "�����ͥ���ư����",
      TSR_PRM_GLOBAL          => {TSR_OBJ_INIRTN => "�����Х������롼����ˤ��롥",
                                  TSR_OBJ_TERRTN => "�����Х뽪λ�롼����ˤ��롥"},
      TSR_PRM_GCOV_ALL        => "���٤Ƥν��������",
      TSR_PRM_GCOV            => "�������롥",
      TSR_PRM_SUPPORT_GET_UTM => "API��get_utm�򥵥ݡ��Ȥ��롥",
      TSR_PRM_SUPPORT_ENA_INT => "API��ena_int�򥵥ݡ��Ȥ��롥",
      TSR_PRM_SUPPORT_DIS_INT => "API��dis_int�򥵥ݡ��Ȥ��롥"
    },

    # false�ζ���
    TSR_STT_FALSE => {
      TSR_PRM_LOCCPU          => "��å��������",
      TSR_PRM_DISDSP          => "�ػ߲������",
      TSR_PRM_GAIN_TIME       => "�������",
      TSR_PRM_ENA_EXC_LOCK    => "CPU��å����CPU�㳰ȯ����ػ�",
      TSR_PRM_DO              => "�����ͥ�ư����",
      TSR_PRM_GLOBAL          => {TSR_OBJ_INIRTN => "�����Х������롼����ˤ��ʤ���",
                                  TSR_OBJ_TERRTN => "�����Х뽪λ�롼����ˤ��ʤ���"},
      TSR_PRM_GCOV_ALL        => "�����ν����Τ߼���",
      TSR_PRM_GCOV            => "�������ʤ���",
      TSR_PRM_SUPPORT_GET_UTM => "API��get_utm�򥵥ݡ��Ȥ��ʤ���",
      TSR_PRM_SUPPORT_ENA_INT => "API��ena_int�򥵥ݡ��Ȥ��ʤ���",
      TSR_PRM_SUPPORT_DIS_INT => "API��dis_int�򥵥ݡ��Ȥ��ʤ���"
    },

    # �����ͥ���٥ޥ����ξ���
    TSR_PRM_CHGIPM => {
      KER_TIPM_ENAALL => "���������",
      0               => "���������"
    },

    # variation�Υ����ޡ��ȳ���ߤξ���
    TSR_PRM_TIMER_GLOBAL    => "�����Х�",
    TSR_PRM_TIMER_LOCAL     => "������",
    TSR_PRM_IRC_GLOBAL      => "�����Х�",
    TSR_PRM_IRC_LOCAL       => "������",
    TSR_PRM_IRC_COMBINATION => "�����Х�ȥ�����",

    # �������㳰�����ξ���
    TSR_STT_TTEX_DIS => "�ػ߾���",
    TSR_STT_TTEX_ENA => "���ľ���",

    # ���ԥ��å��ξ���
    TSR_STT_TSPN_LOC => "��������Ƥ������",
    TSR_STT_TSPN_UNL => "��������Ƥ��ʤ�����",

    # �ץ��å�
    CFG_MCR_PRC_SELF    => "���ץ��å�",
    CFG_MCR_PRC_OTHER   => "¾�ץ��å�",
    CFG_MCR_PRC_OTHER_1 => "¾�ץ��å�_1",
    CFG_MCR_PRC_OTHER_2 => "¾�ץ��å�_2",

    # ���٥�ȥե饰���Ԥ��⡼��
    KER_TWF_ORW  => "OR",
    KER_TWF_ANDW => "AND",

    # �ѿ�������
    TYP_VOID_P      => "����Ĺ����֥�å�����Ƭ����(void*)",
    TYP_INTPTR_T    => "�ݥ��󥿤��Ǽ�Ǥ�������դ�����(intptr_t)",
    TYP_PRI         => "ͥ����(PRI)",
    TYP_ID          => "������ID�����������ΰ�ؤΥݥ���(ID)",
    TYP_FLGPTN      => "���٥�ȥե饰�Υӥåȥѥ�����(FLGPTN)",
    TYP_T_RALM      => "���顼��ϥ�ɥ�θ��߾��֤������ѥ��å�(T_RALM)",
    TYP_T_RCYC      => "�����ϥ�ɥ�θ��߾��֤������ѥ��å�(T_RCYC)",
    TYP_T_RTSK      => "�������θ��߾��֤������ѥ��å�(T_RTSK)",
    TYP_T_TTSP_RTSK => "�������θ��߾��֤������ѥ��å�(T_TTSP_RTSK)",
    TYP_T_RTEX      => "�������㳰�����θ��߾��֤������ѥ��å�(T_RTEX)",
    TYP_T_RSEM      => "���ޥե��θ��߾��֤������ѥ��å�(T_RSEM)",
    TYP_T_RFLG      => "���٥�ȥե饰�θ��߾��֤������ѥ��å�(T_RFLG)",
    TYP_T_RDTQ      => "�ǡ������塼�θ��߾��֤������ѥ��å�(T_RDTQ)",
    TYP_T_RPDQ      => "ͥ���٥ǡ������塼�θ��߾��֤������ѥ��å�(T_RPDQ)",
    TYP_T_RMBX      => "�᡼��ܥå����θ��߾��֤������ѥ��å�(T_RMBX)",
    TYP_T_RMPF      => "����Ĺ����ס���θ��߾��֤������ѥ��å�(T_RMPF)",
    TYP_T_RSPN      => "���ԥ��å��θ��߾��֤򤤤��ѥ��å�(T_RSPN)",
    TYP_T_MSG       => "�᡼��ܥå����Υ�å������إå�(T_MSG)",
    TYP_T_P_MSG     => "�᡼��ܥå����Υ�å������إå��ݥ���(T_MSG*)",
    TYP_T_MSG_PRI   => "ͥ�����դ���å������إå�(T_MSG_PRI)",
    TYP_SYSTIM      => "�����ƥ��������������ΰ�(SYSTIM)",
    TYP_SYSUTM      => "�����ƥ��������������ΰ�(SYSUTM)"
  }
end
